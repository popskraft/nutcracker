# Архитектура Инициализации Мульти-Агентной Разработки (VS Code + GPT-5.3+ + Claude Code)

## 1. Цель
Этот документ задает единый стандарт работы для Claude Code и OpenAI GPT-5.3+/Codex в VS Code, чтобы:
- запускать проект в одной LLM и завершать в другой без потери контекста;
- работать в VS Code через два расширения (GPT-5.3+ и Claude Code) с одинаковыми правилами;
- поддерживать как автономный pipeline, так и ручной/hybrid режим.

Главный принцип: состояние проекта хранится в репозитории (файлы), а не в истории конкретного чата.

## 1.1 Специфика текущего проекта Nutcracker
- Основной стек: `Carrd.co markup -> Hugo`.
- Источник современной референс-разметки: `carrd/`.
- Абсолютный путь референса в текущем проекте:
  `/Users/popskraft/hugo/nutcracker/carrd`
- Рабочий baseline-сайт (операционная референс-версия):
  `https://nutcrackerpro.com/`

## 2. Что создается при инициализации
Инициализация создает универсальный AI-контур:
- `AGENTS.md` (единый контракт для всех агентов)
- `CLAUDE.md` и `.codex/AGENTS.md` (entry points к одному контракту)
- `_docs/` (архитектура, стек, conventions, домен, status)
- `.ai/` (tasks, plans, handoff, decisions/ADR, reviews, contracts, logs)
- `.claude/` и `.codex/` (локальные каталоги для промптов/skills)
- `_docs/REFERENCE_BASELINE.md` (правила сравнения с Carrd и production baseline)
- `_docs/VSCODE_AGENT_SETUP.md` (режим работы двух расширений в VS Code)

## 3. Поддерживаемые профили проектов
- `carrd-hugo-landing`
- `carrd-hugo-corporate`
- `carrd-processwire-corporate`
- `bootstrap-processwire-corporate`
- `tailwind-processwire-corporate`

Таким образом один и тот же протокол синхронизации покрывает ваши основные сценарии.

## 4. Режимы автоматизации
- `autonomous`: агент проходит полный цикл (plan -> implement -> validate -> handoff).
- `hybrid`: переходы между фазами подтверждаются человеком.
- `manual`: человек контролирует каждый шаг и merge.

## 5. Команда инициализации
Запуск из корня проекта:

```bash
scripts/init-ai-workspace.sh \
  --project-type carrd-hugo-corporate \
  --automation-mode autonomous \
  --ide vscode,gpt-5.3+-extension,claude-code-extension \
  --reference-dir carrd \
  --baseline-url https://nutcrackerpro.com/
```

Опция `--force` перезапишет уже существующие bootstrap-файлы AI-контура.

## 6. Протокол синхронизации между LLM
Каждая сессия обязана идти в одном порядке:
1. Читать `_docs/STATUS.md` и `.ai/tasks/CURRENT.md`.
2. Читать `_docs/REFERENCE_BASELINE.md` и `_docs/VSCODE_AGENT_SETUP.md`.
3. Создать/обновить план в `.ai/plans/`.
4. Выполнить реализацию в отдельной ветке/worktree.
5. Запустить проверки по стеку.
6. Сравнить результат с `carrd/` и проверить baseline-сайт.
7. Зафиксировать handoff в `.ai/handoff/`.
8. Обновить `_docs/STATUS.md`.

Это гарантирует переносимость между Claude Code и Codex без зависимости от истории чата.

## 7. Пошаговая проверка адекватности (sanity gates)
После инициализации проверьте:
1. `AGENTS.md` существует и содержит правильный `project-type`.
2. `_docs/STACK.md` содержит актуальные команды dev/build/validate.
3. `.ai/contracts/PROJECT_PROFILE.yaml` соответствует выбранному профилю.
4. `.ai/handoff/_TEMPLATE.md` и `.ai/plans/_TEMPLATE.md` доступны для старта задач.
5. В `_docs/STATUS.md` записан текущий режим (`autonomous|hybrid|manual`).
6. В `_docs/REFERENCE_BASELINE.md` зафиксированы `carrd/` и `https://nutcrackerpro.com/`.

Если любой пункт не выполняется, pipeline считается неинициализированным.

## 8. Что делать сразу после bootstrap
1. Заполнить `.ai/tasks/CURRENT.md` первой реальной задачей.
2. Создать первый план в `.ai/plans/`.
3. Выполнить задачу и оформить первый handoff.
4. Для изменений архитектуры открыть ADR в `.ai/decisions/`.
