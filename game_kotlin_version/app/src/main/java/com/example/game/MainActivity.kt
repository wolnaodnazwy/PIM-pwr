package com.example.game


import android.annotation.SuppressLint
import android.os.Bundle
import android.view.MotionEvent
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {

    private lateinit var btnConfirm: ImageButton
    private lateinit var btnBackspace: ImageButton

    private var currentInput = "0"
    private var targetNumber = generateRandomNumber()
    private var attemptsLeft = 10

    private lateinit var tvNumber: TextView
    private lateinit var tvAttempts: TextView
    private lateinit var btnIncrease: ImageButton
    private lateinit var btnDecrease: ImageButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        tvNumber = findViewById(R.id.tv_number)
        tvAttempts = findViewById(R.id.tv_attempts)
        btnIncrease = findViewById(R.id.btn_increase)
        btnDecrease = findViewById(R.id.btn_decrease)
        btnConfirm = findViewById(R.id.btn_confirm)
        btnBackspace = findViewById(R.id.btn_backspace)

        updateDisplayNumber()
        updateAttempts()

        val numberButtons = listOf(
            findViewById<Button>(R.id.btn_0),
            findViewById<Button>(R.id.btn_1),
            findViewById<Button>(R.id.btn_2),
            findViewById<Button>(R.id.btn_3),
            findViewById<Button>(R.id.btn_4),
            findViewById<Button>(R.id.btn_5),
            findViewById<Button>(R.id.btn_6),
            findViewById<Button>(R.id.btn_7),
            findViewById<Button>(R.id.btn_8),
            findViewById<Button>(R.id.btn_9)
        )

        numberButtons.forEach { button ->
            button.setOnClickListener {
                addNumber(button.text.toString())
            }
        }

        setupPressEffect(btnBackspace) { removeLastDigit() }
        setupPressEffect(btnConfirm) { confirmNumber() }

        findViewById<ImageButton>(R.id.btn_flag).setOnClickListener {
            showSurrenderDialog()
        }
    }

    private fun generateRandomNumber(start: Int = 0, end: Int = 100): Int {
        return (start..end).random()
    }

    private fun addNumber(digit: String) {
        if (currentInput == "0") {
            currentInput = digit
        } else {
            currentInput += digit
        }
        updateDisplayNumber()
    }

    private fun removeLastDigit() {
        if (currentInput.isNotEmpty()) {
            currentInput = currentInput.dropLast(1)
            if (currentInput.isEmpty()) {
                currentInput = "0"
            }
            updateDisplayNumber()
        }
    }

    private fun confirmNumber() {
        val enteredNumber = currentInput.toIntOrNull() ?: 0
        if (enteredNumber == targetNumber) {
            showWinDialog()
        } else {
            attemptsLeft--
            updateAttempts()
            updateArrowColors(enteredNumber)
            if (attemptsLeft <= 0) {
                showDefeatDialog()
            }
        }
    }

    private fun updateArrowColors(enteredNumber: Int) {
        if (enteredNumber > targetNumber) {
            btnIncrease.setColorFilter(ContextCompat.getColor(this, R.color.pink))
            btnDecrease.setColorFilter(ContextCompat.getColor(this, R.color.grey))
        } else {
            btnDecrease.setColorFilter(ContextCompat.getColor(this, R.color.pink))
            btnIncrease.setColorFilter(ContextCompat.getColor(this, R.color.grey))
        }
    }

    private fun updateDisplayNumber() {
        tvNumber.text = currentInput
    }

    @SuppressLint("SetTextI18n")
    private fun updateAttempts() {
        tvAttempts.text = "Liczba pozostałych prób: $attemptsLeft"
    }

    private fun resetGame() {
        currentInput = "0"
        attemptsLeft = 10
        targetNumber = generateRandomNumber()
        btnIncrease.setColorFilter(ContextCompat.getColor(this, R.color.pink))
        btnDecrease.setColorFilter(ContextCompat.getColor(this, R.color.pink))
        updateDisplayNumber()
        updateAttempts()
    }

    private fun showWinDialog() {
        val alertDialog = AlertDialog.Builder(this, R.style.CustomAlertDialogTheme)
            .setTitle("Wygrałeś!")
            .setMessage("Brawo, udało ci się zgadnąć liczbę")
            .setPositiveButton("Zagraj ponownie") { dialog, _ ->
                dialog.dismiss()
                resetGame()
            }
            .create()
        alertDialog.setOnShowListener {
            val width = (resources.displayMetrics.widthPixels * 0.8).toInt()
            alertDialog.window?.setLayout(width, WindowManager.LayoutParams.WRAP_CONTENT)
        }
        alertDialog.show()
    }

    private fun showDefeatDialog() {
        val alertDialog = AlertDialog.Builder(this, R.style.CustomAlertDialogTheme)
            .setTitle("Przegrałeś")
            .setMessage("Ilość prób się skończyła\n\nOczekiwana liczba to: $targetNumber")
            .setPositiveButton("Zagraj ponownie") { dialog, _ ->
                dialog.dismiss()
                resetGame()
            }
            .create()
        alertDialog.setOnShowListener {
            val width = (resources.displayMetrics.widthPixels * 0.8).toInt()
            alertDialog.window?.setLayout(width, WindowManager.LayoutParams.WRAP_CONTENT)
        }
        alertDialog.show()
    }

    private fun showSurrenderDialog() {
        val alertDialog = AlertDialog.Builder(this, R.style.CustomAlertDialogTheme)
            .setTitle("Poddać się?")
            .setMessage("Czy na pewno chcesz się poddać?\n\nTej czynności nie da się cofnąć")
            .setPositiveButton("Tak") { dialog, _ ->
                dialog.dismiss()
                showSurrenderConfirmDialog()
            }
            .setNegativeButton("Nie") { dialog, _ ->
                dialog.dismiss()
            }
            .create()
        alertDialog.setOnShowListener {
            val width = (resources.displayMetrics.widthPixels * 0.8).toInt()
            alertDialog.window?.setLayout(width, WindowManager.LayoutParams.WRAP_CONTENT)
        }
        alertDialog.show()
    }


    private fun showSurrenderConfirmDialog() {
        val alertDialog = AlertDialog.Builder(this, R.style.CustomAlertDialogTheme)
            .setTitle("Przegrałeś")
            .setMessage("Poddałeś się\n\nOczekiwana liczba to: $targetNumber")
            .setPositiveButton("Zagraj ponownie") { dialog, _ ->
                dialog.dismiss()
                resetGame()
            }
            .create()

        alertDialog.setOnShowListener {
            val width = (resources.displayMetrics.widthPixels * 0.8).toInt()
            alertDialog.window?.setLayout(width, WindowManager.LayoutParams.WRAP_CONTENT)
        }

        alertDialog.show()
    }


    @SuppressLint("ClickableViewAccessibility")
    private fun setupPressEffect(button: ImageButton, action: () -> Unit) {
        button.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    button.setBackgroundResource(R.drawable.icon_button_container_background_hover)
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                    button.setBackgroundResource(R.drawable.icon_button_container_background)
                    action()
                }
            }
            true
        }
    }
}