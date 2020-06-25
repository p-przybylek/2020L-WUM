import sys
from random import randint
import pandas as pd
from joblib import load
import numpy as np

from PyQt5.QtCore import QUrl, QObject
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

initial_url = QUrl('main.qml')

path_to_models = "../final-model/"

columns = ['Administrative', 'Administrative_Duration', 'Informational',
           'Informational_Duration', 'ProductRelated', 'ProductRelated_Duration',
           'BounceRates', 'ExitRates', 'PageValues', 'SpecialDay', 'Month',
           'OperatingSystems', 'Browser', 'Region', 'TrafficType', 'VisitorType',
           'Weekend']

buy_chances = {"1": "19%",
               "2": "24%",
               "3": "10%%",
               "4": "19%",
               "5": "7%",
               "6": "10%"}

user_actions = {colname: 0 for colname in columns}


def _create_app(arg):
    app = QGuiApplication(arg)
    return app


def _create_engine(url):
    engine = QQmlApplicationEngine()
    engine.load(url)
    return engine


class QmlControllerBase:

    def __init__(self, arg):
        self.app = _create_app(arg)
        self.engine = _create_engine(initial_url)
        self.root = self.engine.rootObjects()[0]

        self.models = load(path_to_models + 'models.joblib')
        self.encoders = load(path_to_models + 'encoders.joblib')
        self.scaler = load(path_to_models + 'scaler_numeric.joblib')

    def element(self, name):
        return self.root.findChild(QObject, name)

    def set_prop(self, name, value):
        self.engine.rootContext().setContextProperty(name, value)


class QmlControllerSignals(QmlControllerBase):
    def __init__(self, arg):
        super().__init__(arg)

    def bind_signals(self):
        self.element('MainPage').start.connect(self.on_start)
        self.element("WebSimulator").updateInfo.connect(self.on_update_info)

    def on_start(self, month, special_day, visitor_type, os, browser, region, traffic_type):
        global user_actions
        if month == "Random":
            month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Oct", "Sep", "Nov", "Dec"][randint(0, 11)]

        if special_day == "Random":
            special_day = [0.0, 0.2, 0.4, 0.6, 0.8, 1][randint(0, 5)]

        if visitor_type == "Random":
            visitor_type = ["Returning_Visitor", "New_Visitor", "Other"][randint(0, 1)]

        if os == "Random":
            os = randint(1, 5)
        if browser == "Random":
            browser = randint(1, 5)
        if region == "Random":
            region = randint(1, 5)
        if traffic_type == "Random":
            traffic_type = randint(1, 5)

        self.set_prop("month", month)
        self.set_prop("special_day", special_day)
        self.set_prop("visitor_type", visitor_type)
        self.set_prop("os", os)
        self.set_prop("region", region)
        self.set_prop("browser", browser)
        self.set_prop("traffic_type", traffic_type)

        user_actions["Month"] = month
        user_actions["SpecialDay"] = float(special_day)
        user_actions["VisitorType"] = visitor_type
        user_actions["OperatingSystems"] = int(os)
        user_actions["Region"] = int(region)
        user_actions["Browser"] = int(browser)
        user_actions["TrafficType"] = int(traffic_type)

        print(user_actions)

        self.updatePrediction(user_actions)

    def on_update_info(self, column_name, time_spend):
        global user_actions

        user_actions[column_name] += 1
        user_actions[(column_name + "_Duration")] = abs(time_spend)

        #print(user_actions)

        self.updatePrediction(user_actions)

    def updatePrediction(self, data_dict):

        row = dict_to_row(data_dict)
        row = self.transform(row)
        prediction = self.predict(row)
        buy_chance = get_buy_chance(prediction)

        self.set_prop("cluster_nr", prediction)
        self.set_prop("buy_chance", buy_chance)

    def transform(self, data):
        # Month
        month_to_int = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'June': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9,
                        'Oct': 10, 'Nov': 11, 'Dec': 12}
        data['Month'] = data['Month'].replace(month_to_int)

        data['Month_x'] = data['Month'].transform(lambda x: np.sin((np.pi / 6) * x))
        data['Month_y'] = data['Month'].transform(lambda x: np.cos((np.pi / 6) * x))

        data = data.drop('Month', axis=1)

        # Encodeing categorical values
        values_to_leave = {'VisitorType': ["Returning_Visitor", "New_Visitor", "Other"],
                           'OperatingSystems': [2, 1, 3, 4],
                           'Browser': [2, 1, 4, 5],
                           'Region': [1, 3, 4, 2],
                           'TrafficType': [2, 1, 3, 4]}

        variables = ['VisitorType', 'OperatingSystems', 'Browser', 'Region', 'TrafficType']

        for i, variable in enumerate(variables):
            data[variable] = data[variable].transform(
                lambda x: x if (x in values_to_leave[variable]) else 'other').astype(
                str)

            encoder = self.encoders[i]
            temp = pd.DataFrame(encoder.transform(data[[variable]]))
            temp.columns = encoder.get_feature_names([variable])
            data = pd.concat([data, temp], axis=1)
            data = data.drop(variable, axis=1)

        # Numeric values
        variables = ['Administrative', 'Administrative_Duration', 'Informational', 'Informational_Duration',
                     'ProductRelated', 'ProductRelated_Duration', 'BounceRates', 'ExitRates', 'PageValues']
        data[variables] = self.scaler.transform(data[variables])

        # To bools
        nonbools = ['Weekend']

        for variable in nonbools:
            data[variable] = data[variable].transform(lambda x: 1 if x else 0)

        return data

    def predict(self, data):
        max_proba = 0
        cluster = 0

        for i, model in enumerate(self.models):
            proba_all = model.predict_proba(data)
            proba = proba_all[0][1]
            print(f"Model {i+1}: {proba}")
            if proba > max_proba:
                max_proba = proba
                cluster = i + 1

        return cluster


class QmlController(QmlControllerSignals):
    def start(self):
        self.bind_signals()
        self.app.exec_()


def dict_to_row(data_dict_oryginal):
    data_dict = data_dict_oryginal.copy()
    for key in data_dict.keys():
        data_dict[key] = [data_dict[key]]
    return pd.DataFrame.from_dict(data_dict)


def get_buy_chance(cluster_nr):
    return buy_chances[str(cluster_nr)]


if __name__ == "__main__":
    controller = QmlController(sys.argv)
    controller.start()
