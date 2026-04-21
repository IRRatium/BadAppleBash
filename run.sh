#!/bin/bash
# Original code: Nguyen Khac Trung Kien
# Fork by: Felipe Avelar
# Python Perfect Sync + Centered Video Mod

# Exit on error
set -e

# Set script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Check if mpv is installed
if ! command -v mpv &> /dev/null; then
    echo "Ошибка: mpv не установлен. Установите его для звука."
    exit 1
fi

# Set frames directory and export it for Python
export FRAMES_DIR="${SCRIPT_DIR}/frames-ascii"

# Validate frames directory
if [[ ! -d "$FRAMES_DIR" ]]; then
    echo "Error: Frames directory not found at $FRAMES_DIR"
    exit 1
fi

# Очищаем экран и скрываем курсор
printf "\033c"
tput civis

# Запускаем музыку
mpv "${SCRIPT_DIR}/bad_apple.mp3" > /dev/null 2>&1 &
MPV_PID=$!

# При закрытии (Ctrl+C) убиваем mpv, возвращаем курсор и очищаем экран
trap 'tput cnorm; kill $MPV_PID 2>/dev/null || true; printf "\033c"' EXIT INT TERM

# Запускаем Python с центрированием
python3 << 'EOF'
import os, sys, time, shutil

frames_dir = os.environ.get('FRAMES_DIR')

# Собираем и сортируем кадры
frames = sorted([f for f in os.listdir(frames_dir) if os.path.isfile(os.path.join(frames_dir, f))],
    key=lambda x: int("".join(filter(str.isdigit, x)) or 0)
)

if not frames:
    sys.exit("Error: No frames found.")

fps = 30.0 

# Читаем первый кадр, чтобы понять его размеры (ширину и высоту ASCII-арта)
with open(os.path.join(frames_dir, frames[0]), "r", encoding="utf-8") as f:
    first_frame_lines = f.read().splitlines()
    frame_height = len(first_frame_lines)
    frame_width = max(len(line) for line in first_frame_lines) if first_frame_lines else 0

start_time = time.time()

for i, filename in enumerate(frames):
    filepath = os.path.join(frames_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()
    
    # Получаем ТЕКУЩИЙ размер терминала (адаптируется к изменению размера окна)
    term_cols, term_lines = shutil.get_terminal_size()
    
    # Вычисляем отступы для центрирования
    pad_y = max(0, (term_lines - frame_height) // 2)
    pad_x = max(0, (term_cols - frame_width) // 2)
    
    # Собираем итоговую строку для вывода
    # \033[H - курсор в начало
    out = '\033[H' + ('\n' * pad_y) 
    
    left_spaces = ' ' * pad_x
    for line in lines:
        # \033[K стирает хвост строки (предотвращает мусор, если окно расширили)
        out += left_spaces + line + '\033[K\n'
        
    # \033[J стирает всё, что осталось ниже видео (чтобы не было дублей)
    out += '\033[J'
    
    # Идеальная синхронизация
    expected_time = start_time + (i / fps)
    current_time = time.time()
    
    if expected_time > current_time:
        time.sleep(expected_time - current_time)
        
    sys.stdout.write(out)
    sys.stdout.flush()
EOF