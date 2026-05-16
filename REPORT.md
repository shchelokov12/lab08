# Лабораторная работа №04
## Изучение систем непрерывной интеграции на примере сервиса GitHub Actions
Студент: Щелоков Александр ИУ8-25

GitHub: shchelokov12

Gmail: aesch8877@gmail.com

## Ход работы
### 1. Создание репозитория lab04 и копирование в него из lab02
```
cd ~/workspace
git clone https://github.com/${GITHUB_USERNAME}/lab02 projects/lab04
cd projects/lab04
git remote remove origin
git remote add origin https://github.com/${GITHUB_USERNAME}/lab04
```
### 2. Создание папки для GitHub Actions
```
mkdir -p .github/workflows
```
### 3. Создание файла Cl
```
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Install CMake
      run: sudo apt-get update && sudo apt-get install -y cmake
    
    - name: Configure
      run: cmake -H. -B_build -DCMAKE_INSTALL_PREFIX=_install
    
    - name: Build
      run: cmake --build _build
    
    - name: Install
      run: cmake --build _build --target install
EOF
```
### 4. Отправка кода на GitHub
```
git add .
git commit -m "Add GitHub Actions CI"
git push -u origin main
```

## Вывод
В ходе лабораторной работы была успешно настроена система непрерывной интеграции на основе GitHub Actions, обеспечивающая автоматическую сборку проекта при каждом push в репозиторий.
