package com.example.game


import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.EditText
import android.widget.ImageButton
import android.widget.RadioButton
import android.widget.RadioGroup
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
    private var attemptsMax = 10
    private var numberRangeStart = 0
    private var numberRangeEnd = 100

    private lateinit var tvNumber: TextView
    private lateinit var tvAttempts: TextView
    private lateinit var btnIncrease: ImageButton
    private lateinit var btnDecrease: ImageButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        tvNumber = findViewById(R.id.tv_number)
        tvAttempts = findViewById(R.id.tv_attepmt)
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

        findViewById<ImageButton>(R.id.btn_settings).setOnClickListener {
            showSettings()
        }


        findViewById<Button>(R.id.btn_save_settings).setOnClickListener {
            saveSettings()
        }

        // Załaduj zapisane ustawienia
        val sharedPreferences = getSharedPreferences("game_settings", MODE_PRIVATE)

        // Załaduj zakres liczb
        numberRangeStart = sharedPreferences.getInt("range_start", 0)
        numberRangeEnd = sharedPreferences.getInt("range_end", 100)

        // Załaduj poziom trudności
        val difficultyText = sharedPreferences.getString("difficulty", "Łatwy")

        // Ustaw odpowiednią opcję w RadioGroup
        val difficultyRadioGroup = findViewById<RadioGroup>(R.id.radio_group_difficulty)
        when (difficultyText) {
            "Łatwy" -> difficultyRadioGroup.check(R.id.radio_easy)
            "Średni" -> difficultyRadioGroup.check(R.id.radio_medium)
            "Trudny" -> difficultyRadioGroup.check(R.id.radio_hard)
        }

        resetGame()
    }

    private fun showSettings() {
        val settingsPanel = findViewById<View>(R.id.settings_panel)
        settingsPanel.visibility = View.VISIBLE
    }

    private fun saveSettings() {
        val settingsPanel = findViewById<View>(R.id.settings_panel)
        settingsPanel.visibility = View.GONE

        // Pobierz wartości z EditText (zakres liczb)
        val newRangeStart = findViewById<EditText>(R.id.editTextText).text.toString().toIntOrNull() ?: 0
        val newRangeEnd = findViewById<EditText>(R.id.editTextText2).text.toString().toIntOrNull() ?: 100

        // Sprawdź, czy zakres się zmienił
        val isRangeChanged = numberRangeStart != newRangeStart || numberRangeEnd != newRangeEnd
        numberRangeStart = newRangeStart
        numberRangeEnd = newRangeEnd

        // Pobierz wybrany poziom trudności
        val difficultyRadioGroup = findViewById<RadioGroup>(R.id.radio_group_difficulty)
        val selectedDifficultyId = difficultyRadioGroup.checkedRadioButtonId
        val selectedDifficultyRadioButton = findViewById<RadioButton>(selectedDifficultyId)

        // Sprawdź, czy poziom trudności się zmienił
        val newAttemptsMax = when (selectedDifficultyRadioButton.id) {
            R.id.radio_easy -> 10
            R.id.radio_medium -> 6
            R.id.radio_hard -> 2
            else -> attemptsMax
        }

        val isDifficultyChanged = attemptsMax != newAttemptsMax
        attemptsMax = newAttemptsMax

        // Zaktualizuj zmienną attemptsLeft (poziom trudności)
        attemptsLeft = attemptsMax

        // Jeśli którykolwiek z warunków się zmienił, zresetuj grę
        if (isRangeChanged || isDifficultyChanged) {
            resetGame()
        }
    }

    private fun generateRandomNumber(start: Int = numberRangeStart, end: Int = numberRangeEnd): Int {
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
        attemptsLeft = attemptsMax
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