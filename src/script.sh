#!/bin/bash

rows=10
cols=20

snake=("0,0")
snake_length=1

generate_food() {
    food_row=$((RANDOM % rows))
    food_col=$((RANDOM % cols))
    food="$food_row,$food_col"
}

draw_grid() {
    for ((i = 0; i < rows; i++)); do
        for ((j = 0; j < cols; j++)); do
            cell="$i,$j"
            if [[ "$cell" == "${snake[0]}" ]]; then
                echo -n "H "
            elif [[ " ${snake[@]} " =~ " $cell " ]]; then
                echo -n "S "
            elif [[ "$cell" == "$food" ]]; then
                echo -n "F "
            else
                echo -n ". "
            fi
        done
        echo
    done
}

move_snake() {
    local new_head="$1,$2"
    snake=("$new_head" "${snake[@]:0:snake_length}")
}

check_collision() {
    local head="${snake[0]}"
    IFS=',' read -r row col <<< "$head"

    if [[ $row -lt 0 || $row -ge $rows || $col -lt 0 || $col -ge $cols || " ${snake[@]:1} " =~ " $head " ]]; then
        echo "Game Over!"
        exit
    fi
}

generate_food

while true; do
    clear
    draw_grid

    read -rsn1 direction
    case $direction in
    w) move_snake $((snake[0,0] - 1)) "${snake[0,1]}" ;;
    s) move_snake $((snake[0,0] + 1)) "${snake[0,1]}" ;;
    a) move_snake "${snake[0,0]}" $((snake[0,1] - 1)) ;;
    d) move_snake "${snake[0,0]}" $((snake[0,1] + 1)) ;;
    esac

    check_collision

    if [ "${snake[0]}" == "$food" ]; then
        snake_length=$((snake_length + 1))
        generate_food
    fi

    sleep 0.5
done
