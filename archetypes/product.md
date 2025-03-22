---
type: product
layout: product
date: {{ .Date }}

# SEO metadata
seoTitle: "{{ replace .Name "-" " " | title }} | Nutcracker Pro"
seoDescription: >-
  Professional-grade {{ replace .Name "-" " " | lower }} from Nutcracker Pro. 

# Page content
title: "**{{ replace .Name "-" " " | title }}**"
subtitle: ""
description: >-
  

# Media
ogImage: /images/{{ .Name }}/ogimage.jpg

# CTA buttons
productLink: "" # e.g. https://akdealerservices.com/product/1000000-product-name
buttonCartText: "Buy Now"
buttonWholesaleText: "Wholesale Inquiry" # Set to false to hide wholesale button

# cover slider (in static folder)
slider:
  - image: "/images/covers/cover-1.webp"
    caption: "Nutcracker Professional Products"
  - image: "/images/covers/cover-2.webp"
    caption: "Quality Tools for Professionals"
  - image: "/images/covers/cover-4.webp"
    caption: "Professional Grade Solutions"

# cover image
coverImage: images/{{ .Name }}/product-cover.png
coverImageMobile: images/{{ .Name }}/product-cover-mobile.png
coverImageAlt: "{{ replace .Name "-" " " | title }} Nutcracker Pro"
coverImageTitle: "Order the"

# features
features:
  - "Feature 1"
  - "Feature 2"
  - "Feature 3"
  - "Feature 4"
  - "Feature 5"

# price section
priceSection:
  title: "Outstanding price"
  price: "$0.00" # e.g. $19.99
  pricePerCaptionLong: "Per unit (wholesale price)"
  priceCaptionInProduct: "Per unit (bulk pricing)"

# products section
products:
  - size: "Option 1" # e.g. size, variant, or package
    image: /images/{{ .Name }}/product-1.jpg
    imageAlt: "Buy {{ replace .Name "-" " " | title }} - Option 1"
    productLink: "" # Individual product link, falls back to page productLink if empty
    buttonText: "Buy Option 1" # Set to false to hide button
    buttonWholesaleText: false # Set to false to hide wholesale button
    priceText: >
      Retail: **$0.00 per unit**
      <br>
      Wholesale: **$0.00 per unit**

  - size: "Option 2"
    image: /images/{{ .Name }}/product-2.jpg
    imageAlt: "Buy {{ replace .Name "-" " " | title }} - Option 2"
    productLink: ""
    buttonText: "Buy Option 2"
    buttonWholesaleText: false
    priceText: >
      Retail: **$0.00 per unit**
      <br>
      Wholesale: **$0.00 per unit**

# benefitsHeader
benefitsHeaderTitle: "Why Choose **{{ replace .Name "-" " " | title }}**?"

# benefitsContent
benefitsImages:
  - image: /images/{{ .Name }}/gallery-1.jpg
    alt: "{{ replace .Name "-" " " | title }} - Feature 1"
  - image: /images/{{ .Name }}/gallery-2.jpg
    alt: "{{ replace .Name "-" " " | title }} - Feature 2"

benefitsBlocks:
  - title: "Key Benefit 1"
    text: >-
      Describe the first key benefit of your product.
  - title: "Key Benefit 2"
    text: >-
      Describe the second key benefit of your product.
  - title: "Key Benefit 3"
    text: >-
      Describe the third key benefit of your product.
  - title: "Key Benefit 4"
    text: >-
      Describe the fourth key benefit of your product.
  - title: "Key Benefit 5"
    text: >-
      Describe the fifth key benefit of your product.
  - title: "Key Benefit 6"
    text: >-
      Describe the sixth key benefit of your product.

# savings section
savings:
  title: "Save with bulk orders"
  subtitle: "Special offer for businesses!"
  description: >-
    Describe your bulk pricing and savings calculations here.

# testimonials section
testimonials:
  title: "Customer Reviews of {{ replace .Name "-" " " | title }}"
  items:
    - name: "Customer Name"
      text: >-
        Customer testimonial text here.
    - name: "Another Customer"
      text: >-
        Another customer testimonial.

# FAQ section
faq:
  title: "{{ replace .Name "-" " " | title }}"
  titleColored: "F.A.Q."
  questions:
    - question: "What makes this product professional grade?"
      answer: >-
        Answer about product quality and professional features.
    - question: "What are the bulk ordering options?"
      answer: >-
        Details about bulk ordering and wholesale pricing.
    - question: "What certifications does this product have?"
      answer: >-
        Information about product certifications and standards.
---
