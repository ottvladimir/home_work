# Домашнее задание к занятию "7.5. Основы golang"

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```Go
    package main

    import "fmt"

    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)

        output := input *  0.3048

        fmt.Println(output)    
    }
    ```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```Go
    package main

    import "fmt"

    func main() {
        x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
        min := x[0]
    for _, y := range x {
            if (y < min) {
                min = y
            }
    }
    fmt.Println(min)
    }
    ```
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

    ```Go
    package main

    import "fmt"

    func main() {
        for i := 0; i < 100; i++ {
          if i%3==0{
            fmt.Println(i)
        }
        }
    }
    ```
