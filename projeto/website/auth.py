from flask import Blueprint, render_template, url_for
# import mysql.connector

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    return render_template('login.html')

@auth.route('/cadastro', methods=['GET', 'POST'])
def cadastro():
    return render_template('cadastro.html')
