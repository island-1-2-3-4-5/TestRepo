//
//  ViewController.swift
//  views
//
//  Created by Roman on 06/09/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
  
    
    // Экранные элементы (неактивные)
    @IBOutlet weak var stepper: UIStepper! // Кнопка +-
    @IBOutlet weak var actionButton: UIButton! // меняем заголовок кнопки
    @IBOutlet weak var timeLabel: UILabel! // Табло с временем
    @IBOutlet weak var gameFieldView: UIView! // Игровое поле
    @IBOutlet weak var shapeX: NSLayoutConstraint! // Привязка к левой стороне поля
    @IBOutlet weak var shapeY: NSLayoutConstraint! // Привязка к верхней части поля
    @IBOutlet weak var gameObject: UIImageView! // игровая фигура
    @IBOutlet weak var scoreLabel: UILabel! // Текст счета игры
    
    
    // Активные экранные элементы
    @IBAction func actionButtonTapped(_ sender: UIButton) { // Кнопка начать
        if isGameActive{
            stopGame()
        } else {
            startGame()
        }
    }
    @IBAction func StepperCganged(_ sender: UIStepper) { // Кнопочка +-, которая меняет значение времени с шагом в 5 секунд( настраивается в меню)
        updateUi()
    }
    // Функция обработки нажатий на объект
    @IBAction func objectTapped(_ sender: UITapGestureRecognizer) {
        guard isGameActive else {return} // проверка на активность игры
        repositionImageWithTimer()
        score += 1 // увеличиваем счет при каждом приксновении
    }
    
    
    
    
    // Переменные
    private var isGameActive = false // индикатор текущей стадии игры
    // переменная для хранения начального времени
    private var gameTimeLeft: TimeInterval = 0 // TimeInterval - тип данных, синоним для Double, предназначен для времени
    private var gameTimer: Timer? // создаем объект таймер
    private var timer: Timer? // переменная времени
    private let displayDuration: TimeInterval = 1 // Время задержки фигуры на поле
    private var score = 0 // переменная для счета
    
    
    // Функции
    // Функции заглушки, игра активна, игра неактивна
    private func startGame() {
        score = 0 // в начале игры обнуляем счет
        repositionImageWithTimer()
        gameTimer?.invalidate() // останавливаем предыдущий таймер перед созданием нового
        gameTimer = Timer.scheduledTimer( // scheduledTimer - метод для таймера
            timeInterval: 1, // обновляем игру каждую секунду
            target: self, // объект у которого нужно вызвать функцию (текущий объект)
            selector: #selector(gameTimerTick), // отложенный вызов функции
            userInfo: nil, // доп инфа, котор ая может быть передана вызваемой функции
            repeats: true // нужно ли повторять вызов функции
        )
       
        gameTimeLeft = stepper.value // Возвращает отсчет времени
        isGameActive = true // Признак активности игры
        updateUi() // Функция
    }
    
    
    
    private func stopGame() {
        isGameActive = false
        updateUi()
        gameTimer?.invalidate() // останавливаем таймер по окончанию
        timer?.invalidate() // останавливаем таймер по окончанию игры
        scoreLabel.text = "Последний счет: \(score)" // в конце игры меняем текст счета
    }
    
    
    private func repositionImageWithTimer() {
        timer?.invalidate() // останавливаем время
        timer = Timer.scheduledTimer(  // scheduledTimer - метод для таймера
            timeInterval: displayDuration, // Время задержки фигуры на поле
            target: self, // объект у которого нужнов ызвать функцию (текущий объект)
            selector: #selector(moveImage), // отложенный вызов функции
            userInfo: nil, // доп инфа, которая может быть передана вызваемой функции
            repeats: true) // нужно ли повторять вызов функции
        timer?.fire() // функция перемещения фигуры будет вызвана сразу же в начале игры
    }
    
    // Пишем функцию для статуса кнопки степпер, чтобы избежать повторения этого кода дважды - timeLabel.text = "Время: \(Int(sender.value)) сек"
    private func updateUi() {
        gameObject.isHidden = !isGameActive // прячет картинку перед началом игры
        stepper.isEnabled = !isGameActive
        if isGameActive {
            stepper.isEnabled = false //  На начало игры мы деактивируем кнопку степпер
            timeLabel.text = "Осталось \(Int(gameTimeLeft)) сек" // меняет заголовок счетчика и выводит остаток времени
            actionButton.setTitle("Остановить", for: .normal) // нормал - статус, кнопка меняет занчение на остановить
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек"
            actionButton.setTitle("Начать", for: .normal)
        }
    }
    
    
    
    
    // функция заглушка, передадим её сигнатуру в selector
    @objc private func gameTimerTick () {
        gameTimeLeft -= 1 // отнимаем еденицу от времени
        if gameTimeLeft <= 0 { // по достижению 0, игра останавливается
            stopGame()
        } else {
             updateUi() // в ином случае продолжается
        }
       
    }
    
    
    
    // Эта функция двигает изображение по таймеру
    @objc private func moveImage() {
        let maxX = gameFieldView.bounds.maxX - gameObject.frame.width // оно само считает максимальные границы поля
        let maxY = gameFieldView.bounds.maxY - gameObject.frame.height //вычитаем из границ поля размер фигуры(frame), чтобы оно не выходило за пределы
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxX))) // у привязок есть свойство constant, оно определяет расстояние до привязки, сделаем рандом
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxY))) // чтобы все заработатло, необходимо сделать двойную конвертацию из Float в UInt и обратно
    }
    
    
    
    

    // Функция отрисовки игрового поля
    override func viewDidLoad() {
        super.viewDidLoad()
        gameFieldView.layer.borderWidth = 1 // Толщина рамки = 2
        gameFieldView.layer.borderColor = UIColor.gray.cgColor // Цвет серый
        gameFieldView.layer.cornerRadius = 5 // Делаем закругленные края
        updateUi() //это надо для того, чтобы отображение игры до начала работы кода выглядело как при его работе (иконка объекта исчезнет)
    }
}

