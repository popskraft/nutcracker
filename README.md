# Nutcracker Pro - Hugo Website

## Content Editing (RU)

Этот раздел для людей, которые впервые открыли проект и хотят менять контент (тексты, товары, цены, FAQ) без погружения в шаблоны.

### 1) Как устроен контент

- **Данные товара (одно место на весь сайт):** `data/products/*.yaml`
  - Здесь правят название товара, наборы/варианты, характеристики, ссылки, цены (если они включены), изображения (пути), тексты для блоков, которые идут "везде одинаково".
- **Тексты страниц (много страниц на один товар):** `content/**/*.md`
  - Базовая страница товара: `content/<product>.md`
  - Страницы товара для штатов: `content/<state>/<product>.md`
  - Здесь правят заголовки/описания/SEO, локальные вариации текста, блоки страницы (например FAQ в front matter), при необходимости отличаются по штату.

Ключевое правило: если надо поменять что-то **одинаково для всех штатов** (например список фич, карточки вариантов, цены) обычно это `data/products/<product>.yaml`. Если надо поменять **текст на конкретной странице/штате** это `content/.../*.md`.

### 2) Самые частые правки (по шагам)

1. **Поменять название/фичи/варианты товара:** открой `data/products/<product>.yaml` и измени нужные поля.
2. **Поменять заголовок/описание на странице товара:** открой `content/<product>.md` (или `content/<state>/<product>.md`) и измени `title`, `description`, `seo*`.
3. **Поменять FAQ:** обычно это front matter в `content/<product>.md` или `content/<state>/<product>.md` (секция `faq:`).
4. **Поменять картинку:**
   - Если путь начинается с `/images/...`, файл должен лежать в `static/images/...` (чтобы URL совпадал).
   - После замены убедись, что путь в YAML/Markdown указывает на существующий файл.

### 3) Что нельзя делать (частые ошибки)

- Не редактируй `public/` (это сгенерированный билд).
- Не правь `layouts/`, `assets/`, `carrd/`, `.ai/` если задача про контент (это уже разработка/миграция).
- В YAML нельзя использовать табы: только пробелы. Любая ошибка отступов ломает билд.
- Не переименовывай файлы товаров/страниц без необходимости: имя файла = URL-слуг (`hand-cleaner.md` -> `/hand-cleaner/`).

### 4) Минимальный GitHub-процесс для контент-правок

1. Создай ветку от `main` (например `content/hand-cleaner-faq-fix`).
2. Внеси правки, сделай commit с понятным сообщением.
3. Открой Pull Request в `main`.
4. Дождись Netlify Deploy Preview (если включен) и проверь страницу глазами.
5. Смёржи PR в `main` (продакшн-деплой обычно стартует автоматически после merge).

### 5) Если деплой не работает (быстрый чеклист)

1. Посмотри логи билда в Netlify: обычно там прямо указано файл/строка (часто YAML/front matter).
2. Прогони локально то же самое, что делает Netlify: `npm install` и `npm run build`.
3. Типовые причины:
   - Ошибка YAML в `data/products/*.yaml` (отступы, двоеточия, кавычки).
   - Сломан front matter в `content/**/*.md` (нет закрывающего `---`, неправильный YAML внутри).
   - Ссылка на картинку ведёт на несуществующий файл (`/images/...` нет в `static/images/...`).
   - Не совпала версия Hugo: в `netlify.toml` задано `HUGO_VERSION = "0.140.2"`.

### 6) YAML и Markdown: что важно знать (коротко)

**YAML (`data/products/*.yaml`)** это структурированные данные. Это очень важно: одна маленькая ошибка в YAML часто ломает сборку/деплой.

- Отступы: только пробелы (обычно 2), табы нельзя.
- Строки с двоеточиями/символами лучше брать в кавычки: `"text: like this"`.
- Списки начинаются с `-` и должны быть ровно выровнены по отступам.
- Многострочный текст делай через `>-` (склеивает строки) или `|` (сохраняет переносы):
  - `description: >-` удобно для длинных описаний.
- Быстрый sanity-check: после правки YAML прогоняй `npm run build`.

**Markdown (`content/**/*.md`)** это текст страниц + front matter (в начале файла).

- Front matter в Hugo обычно YAML между строками `---` в самом верху файла. Если забыть закрыть `---`, билд упадёт.
- Внутри Markdown можно использовать `**жирный**`, списки `-`, заголовки `#`, ссылки `[текст](url)`.
- Если в front matter используются многострочные поля, предпочитай `>-\n  ...` и следи за отступами.

Типовые проблемы, на которые смотреть в первую очередь:
- YAML/front matter: отступы, лишние/пропущенные `:`, незакрытые кавычки.
- Пути к картинкам: `/images/...` должны соответствовать файлам в `static/images/...`.
- Непреднамеренные изменения URL: переименование `content/<slug>.md` меняет адрес страницы.

## Content Editing (EN)

This is a short guide for content editors (texts, products, FAQ) without touching templates.

### YAML and Markdown (quick notes)

**YAML (`data/products/*.yaml`)** stores structured product data. This is critical: a small YAML syntax mistake often breaks the build/deploy.

- Indentation: spaces only (usually 2). Tabs will break YAML.
- Quote risky strings (especially with `:`): `"text: like this"`.
- Lists use `-` and must align by indentation.
- For long text use `>-` (folded) or `|` (literal newlines).
- After edits, run `npm run build` to catch errors early.

**Markdown (`content/**/*.md`)** stores page text plus front matter at the top of the file.

- Hugo front matter is usually YAML between `---` lines at the very top. Missing the closing `---` will fail the build.
- Markdown supports `**bold**`, lists `-`, headings `#`, links `[text](url)`.
- For multi-line front matter fields, prefer `>-\n  ...` and keep indentation consistent.

Common pitfalls:
- YAML/front matter indentation, missing `:`, unclosed quotes.
- Broken image paths: `/images/...` must exist under `static/images/...`.
- Renaming files changes URLs (`content/<slug>.md` -> `/slug/`).

## Quick Start Guide

This is a [Hugo](https://gohugo.io)-based website that uses templates and YAML data files to generate product pages for different US states. 

### Core Concepts

1. **Templates & Content Separation**
   - Site uses Hugo templates (`layouts/`) to define page structure
   - Content is stored separately in Markdown files (`content/`)
   - Product data is centralized in YAML files (`data/`)

2. **Important Rules**
   - YAML formatting must be exact (spaces, not tabs)
   - Images go in `assets/images/` or `static/images/`
   - Follow the exact frontmatter structure in content files

### Quick Links
- [Hugo Content Management Guide](https://gohugo.io/content-management/organization/)
- [Hugo Template Guide](https://gohugo.io/templates/introduction/)
- [YAML Syntax Guide](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)

### Common Tasks
```bash
# Add new product
1. Create data file:    data/products/new-product.yaml
2. Add content:         content/new-product.md
3. Add state pages:     content/*/new-product.md

# Add new state
1. Create state folder: content/new-state/
2. Copy product pages:  content/*.md → content/new-state/
```

## Table of Contents
- [Content Editing (RU)](#content-editing-ru)
- [Content Editing (EN)](#content-editing-en)
- [Project Structure](#project-structure)
- [Managing Product Data](#managing-product-data)
- [Content Management](#content-management)
- [Adding New Pages](#adding-new-pages)
- [Development](#development)

## Project Structure

```
nutcracker/
├── data/           # Product data files (YAML)
├── content/        # Markdown content files
├── layouts/        # HTML templates
├── assets/         # CSS, JS, and images
└── static/         # Static files
```

## Managing Product Data

### Why Data is Stored in the `data/` Directory

The `data/` directory serves as a central storage for product information:

**Key Point:** Product data is stored in ONE place (`data/products/*.yaml`) while having many state-specific pages in the `content/` directory.

Example structure:
```
data/products/
└── hand-cleaner.yaml         # ONE product data file
    
content/                      # MANY state pages using same data
├── alabama/hand-cleaner.md
├── alaska/hand-cleaner.md
├── arizona/hand-cleaner.md
└── [other states...]
```

**When to Edit Files:**
- To change product info (prices, features, images) → edit `data/products/*.yaml`
- To change state-specific content → edit files in `content/[state]/*.md`

### Product Data Files Location
All product data is stored in YAML files under the `data/products/` directory:
```
data/products/
├── hand-cleaner.yaml          # Hand cleaner product data
├── industrial-absorbent-pads.yaml  # Absorbent pads data
├── industrial-wipes-roll.yaml  # Industrial wipes data
└── nitrile-gloves.yaml        # Nitrile gloves data
```

Each product file contains:
- Basic product information (name, price, links)
- Media assets and images
- Product features and benefits
- Pricing tiers (retail and wholesale)
- Marketing content (testimonials, savings calculations)

### Product YAML Structure
Below is the complete structure for a product data file with all available fields:

```yaml
# Basic Product Information
weight: "4"                    # Product weight for sorting
productName: "Product Name"    # Full product name
price: "$39"                   # Retail price
priceWholesale: "$34"         # Wholesale price
pricePerCaptionLong: "Per 200-pad pack (wholesale price, pallet)"
pricePerCaptionShort: "Per pack"
productLink: "https://example.com/product"    # Retail product link
productLinkWholesale: "https://example.com/wholesale"  # Wholesale link

# Media Assets
ogImage: "/images/product/ogimage.jpg"        # Open Graph image
coverImage: "/images/product/cover.png"       # Desktop cover image
coverImageMobile: "/images/product/mobile.png" # Mobile cover image
coverImageTitle: "Order the"                  # Cover title prefix
coverImageAlt: "Product Name Description"     # Image alt text

# Slider Configuration
slider:
  - image: "/images/covers/slide1.webp"
  - image: "/images/covers/slide2.webp"
  - image: "/images/covers/slide3.webp"

# Call-to-Action
buttonCartText: "Buy Now"

# Price Section
priceSection:
  title: "Best price"

# Product Features
features:
  - "Feature 1"
  - "Feature 2"
  - "Feature 3"

# Product Variants
products:
  - size: ""
    image: "/images/product/variant1.jpg"
    imageAlt: "Variant 1 Description"
    buttonText: "Buy Now"
    buttonWholesaleText: "Wholesale"
    priceText: "Retail Price Info"
    priceTextWholesale: "Wholesale Price Info"
    wholesalePrice: true

# Benefits Section
benefitsImages:
  - image: "/images/product/benefit1.jpg"
  - image: "/images/product/benefit2.jpg"

# Gallery Section
gallery:
  items:
    - image: "/images/product/gallery1.jpg"
      alt: "Gallery Image 1 Description"

# Savings Calculator
savings:
  title: "Save up to $X,XXX a year"
  description: "Detailed savings description with **markdown** support"
```

## Content Management

### Product Pages
Product pages are stored in two locations:

1. Base product pages in `content/`:
   ```
   content/
   ├── hand-cleaner.md
   ├── industrial-absorbent-pads.md
   ├── industrial-wipes-roll.md
   └── nitrile-gloves.md
   ```

2. State-specific product pages in `content/[state]/`:
   ```
   content/california/
   ├── _index.md
   ├── hand-cleaner.md
   ├── industrial-absorbent-pads.md
   └── nitrile-gloves.md
   ```

### Product Page Frontmatter
Here's the complete frontmatter structure for product pages:

```yaml
---
type: product
layout: product
date: 2025-04-14T13:48:15+04:00
sitemap:
  priority: 1
  changefreq: "weekly"

# SEO metadata
seoTitleSuffix: "- Product Category"
seoDescription: >-
  Detailed SEO description of the product

# Page content
title: "Product **Name**"    # Supports markdown
description: >-
  Detailed product description with **markdown** support

# Benefits Content
benefitsImages:
  - image: "/images/product/main.jpg"
    alt: "Image description"

benefitsBlocks:
  - title: "Benefit Title"
    text: >-
      Benefit description with support for markdown

# Testimonials
testimonials:
  items:
    - name: "Customer Name"
      text: >-
        Customer testimonial text

# FAQ Section
faq:
  titleColored: "F.A.Q."
  questions:
    - question: "Question text?"
      answer: >-
        Detailed answer with support for markdown
---
```

## Adding New Pages

### Adding a New Product

1. Create product data file in `data/products/`:
   ```bash
   touch data/products/new-product.yaml
   ```

2. Create base product page:
   ```bash
   touch content/new-product.md
   ```

3. Create state-specific product pages:
   ```bash
   for state in content/*/; do
     touch "$state/new-product.md"
   done
   ```

### Adding a New State

1. Create state directory:
   ```bash
   mkdir content/new-state
   ```

2. Create state index:
   ```bash
   touch content/new-state/_index.md
   ```

3. Copy product pages:
   ```bash
   for product in content/*.md; do
     if [ -f "$product" ]; then
       cp "$product" "content/new-state/"
     fi
   done
   ```

## Development

### Local Development
```bash
# Install dependencies
npm install

# Start development server
hugo server -D
```

### Building for Production
```bash
hugo --minify
```

For more information about Hugo, visit the [official Hugo documentation](https://gohugo.io/documentation/).
