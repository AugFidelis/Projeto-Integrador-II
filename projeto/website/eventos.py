from flask import Blueprint, render_template

eventos = Blueprint('eventos', __name__)

@eventos.route('/criar_evento')
def criar_evento():
    return render_template('criar_evento.html')

@eventos.route('/apostar')
def apostar():
    return render_template('aposta.html')
