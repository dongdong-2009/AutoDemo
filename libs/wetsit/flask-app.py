#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    This is Flast temple demo as the system under test
    Editor banrieen 09-12
"""


from flask import Flask

app = Flask(__name__)

@app.route("/user/<name>")
def user(name):
    return "<h1>Hello %s ! </h1>"%name

if __name__ == "__main__":
    app.run(debug=True)
