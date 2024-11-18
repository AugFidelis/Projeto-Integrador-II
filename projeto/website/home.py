from flask import Blueprint, render_template, url_for

home = Blueprint('home', __name__)

@home.route('/')
def index():
    return render_template('home.html')

@home.route('/criar_evento')
def criar_evento():
    return render_template('criar_evento.html')

@home.route('/apostar')
def apostar():
    return render_template('aposta.html')
