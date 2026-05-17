# Лабораторная работа №05

Студент: Щелоков Александр ИУ8-25

GitHub: shchelokov12

Gmail: aesch8877@gmail.com

## Ход работы
### 1. Подготовка репозитория
```
export GITHUB_USERNAME=shchelokov12
```
Клонируем предыдущую работу как основу для lab05
```
git clone https://github.com/${GITHUB_USERNAME}/lab04 projects/lab05
cd projects/lab05
git remote remove origin
git remote add origin https://github.com/${GITHUB_USERNAME}/lab05
```

### 2. Добавление GTest как submodule
```
mkdir third-party
git submodule add https://github.com/google/googletest third-party/gtest
cd third-party/gtest && git checkout release-1.8.1 && cd ../..
git add third-party/gtest
git commit -m "added gtest framework"
```

### 3. Модификация CMakeLists.txt (добавление тестов)
Добавляем BUILD_TESTS
```
sed -i '/option(BUILD_EXAMPLES "Build examples" OFF)/a\option(BUILD_TESTS "Build tests" OFF)' CMakeLists.txt
```
Добавляем тестирование в конец файла
```
cat >> CMakeLists.txt << EOF

if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(third-party/gtest)
  file(GLOB \${PROJECT_NAME}_TEST_SOURCES tests/*.cpp)
  add_executable(check \${${PROJECT_NAME}_TEST_SOURCES})
  target_link_libraries(check \${PROJECT_NAME} gtest_main)
  add_test(NAME check COMMAND check)
endif()
EOF
```

### 4. Создание тестов
```
mkdir tests
cat > tests/test1.cpp << EOF
#include <print.hpp>
#include <gtest/gtest.h>

TEST(Print, InFileStream)
{
  std::string filepath = "file.txt";
  std::string text = "hello";
  std::ofstream out{filepath};
  print(text, out);
  out.close();
  std::string result;
  std::ifstream in{filepath};
  in >> result;
  EXPECT_EQ(result, text);
}
EOF
```

### 5. Локальная сборка и запуск тестов
```
cmake -H. -B_build -DBUILD_TESTS=ON
cmake --build _build
cmake --build _build --target test
_build/check
```

### 6. Создание файла для GitHub Actions
```
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOF'
name: C++ CI with GTest

on:
  push:
    branches: [ master, main ]
  pull_request:
    branches: [ master, main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
      with:
        submodules: true 

    - name: Configure CMake
      run: cmake -H. -B_build -DBUILD_TESTS=ON

    - name: Build
      run: cmake --build _build

    - name: Run tests (ctest)
      run: cmake --build _build --target test -- ARGS=--verbose

    - name: Also run check binary directly
      run: _build/check
EOF
```

### 7. Отправка изменений на GITHUB
```
git add .github/workflows/ci.yml
git add tests
git add -p
git commit -m "added tests with GitHub Actions"
git push origin main
```

## Вывод
В ходе выполнения лабораторной работы я добавил в проект фреймворк Google Test, написал модульные тесты и настроил их автоматический запуск через GitHub Actions при каждом push в репозиторий.
