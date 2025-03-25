# Nutcracker Project Documentation

## Project Overview
This is a Hugo-based website for Nutcracker products, converted from a Carrd template. The site is built with modern web standards and includes responsive design for optimal viewing across different devices. The primary focus is on product presentation and information delivery, with a clean, professional design that showcases the products effectively.

## Technical Stack
- **Static Site Generator**: Hugo v0.140.2 (extended version)
- **CSS Framework**: Tailwind CSS v3.3.0
- **Language**: Go Templates (Hugo), HTML5, CSS3
- **Design Source**: Carrd template conversion
- **Performance**: Optimized for maximum speed on all devices
- **Deployment**: Netlify static hosting (nutcrackerpro.netlify.app)

## Design Implementation
- Original design will be implemented from the Carrd template
- All styling and layout will match the existing design in `/carrd` directory
- Assets will be properly optimized for performance

## Project Structure
```
nutcracker/
├── archetypes/          # Content templates
├── assets/              # Process-needed assets
│   ├── css/             # CSS files
│   ├── js/              # JavaScript files
│   ├── tailwind/        # Tailwind CSS configuration
│   │   ├── tailwind.config.js  # Tailwind configuration
│   │   └── tailwind.css        # Tailwind source CSS
│   └── tailwindstyle.css # Compiled Tailwind CSS
├── content/             # Main content directory
│   ├── _index.md        # Homepage content
│   ├── about.md         # About page
│   ├── articles/        # Blog articles
│   ├── privacy-policy.md # Privacy policy
│   ├── products/        # Product pages
│   │   ├── hand-cleaner.md  # Hand cleaner product
│   │   └── nitrile-gloves.md # Nitrile gloves product
│   ├── states/          # State-specific pages
│   └── thank-you.md     # Form submission confirmation
├── data/                # Site data files
│   ├── products/        # Product data
│   └── states/          # State-specific data
├── layouts/             # HTML templates
│   ├── _default/        # Default template files
│   │   ├── baseof.html  # Base template
│   │   ├── list.html    # List template
│   │   └── single.html  # Single template
│   ├── partials/        # Template partials
│   │   ├── benefits/    # Benefits section partials
│   │   ├── forms/       # Form partials
│   │   ├── schema/      # Schema.org JSON-LD partials
│   │   └── coverSlider.html # Cover image/slider partial
│   └── shortcodes/      # Hugo shortcodes
├── static/              # Static assets
│   └── images/          # Image files
└── hugo.yaml            # Hugo configuration
```

## Content Management
### Content Types
- Product Pages
- About Section
- Terms & Conditions
- Privacy Policy
- Contact Forms
- Embedded Media (YouTube/MP4 when needed)

### Content Creation
To create new content:
1. Create markdown files in appropriate content directories
2. Use provided archetypes for consistent structure
3. Follow the existing design patterns from Carrd template
4. Optimize all images and media for performance

## Development
### Local Development
- Run `hugo server -D` for development server
- Access site at `http://localhost:1313`
- `-D` flag shows draft content
- **Server Restart Policy**:
  - Only restart the server when system requirements change or when fixing errors that prevent proper operation
  - For simple content or style changes, server restart is not necessary (Hugo's live reload will handle these changes)
  - Avoid unnecessary server restarts to maintain efficient development workflow

### Tailwind CSS Development
- **Watch Mode**: `npm run tailwind:watch`
  - This command watches for changes in the Tailwind source files and recompiles automatically
  - Command: `npx tailwindcss -i ./assets/tailwind/tailwind.css -o ./assets/tailwindstyle.css --watch --config ./assets/tailwind/tailwind.config.js`

- **Build for Production**: `npm run tailwind:build`
  - This command builds and minifies the Tailwind CSS for production
  - Command: `npx tailwindcss -i ./assets/tailwind/tailwind.css -o ./assets/tailwindstyle.css --minify --config ./assets/tailwind/tailwind.config.js`
  - Run this before deploying to ensure the latest CSS changes are included

- **Tailwind Configuration**:
  - Configuration file: `./assets/tailwind/tailwind.config.js`
  - Content paths: Scans all HTML and Markdown files in layouts, content, and themes directories
  - Core plugins: Container class is disabled, Preflight (reset styles) is disabled to prevent conflicts with existing styles

- **CSS Fingerprinting**:
  - All CSS files (including Tailwind) use Hugo's fingerprinting for cache busting
  - Fingerprinting creates a unique filename based on the file's content (e.g., `tailwindstyle.min.1e11f8d58fd7a75b4c49f5cb7cd7d0e1ec3131ac617d15caf0f8f7f5b393c684.css`)
  - Important: Do not add query parameters (like `?v={{ now.Unix }}`) to fingerprinted files as this defeats the purpose and creates duplicate files
  - Implementation in baseof.html:
    ```html
    {{ with resources.Get "tailwindstyle.css" }}
    {{ $tailwind := . | minify }}
    {{ $tailwind := $tailwind | fingerprint }}
    <link rel="stylesheet" href="{{ $tailwind.RelPermalink }}" integrity="{{ $tailwind.Data.Integrity }}" crossorigin="anonymous">
    {{ end }}
    ```

### Design Implementation
- Maintain exact styling from Carrd template
- Ensure responsive design works on all devices
- Optimize for maximum performance
- Implement proper asset optimization

## Image Processing Pattern

A standard image processing pattern has been established for handling images in Hugo templates:

1. Retrieve image from front matter parameters:
   ```go-html-template
   {{ with .Page.Params.coverImage }}
     {{ $image := resources.Get . }}
     {{ with $image }}
       {{ $filter := images.UnsharpMask .5 .5 0 }}
       {{ $processed := $image.Filter $filter }}
       {{ $final := $processed.Fill "756x756 webp picture Center" }}
       <img 
         src="{{ $final.RelPermalink }}" 
         alt="Image description" 
         title="Image title"
         loading="eager"
       />
     {{ end }}
   {{ end }}
   ```

2. Key components:
   - Double with-check pattern for safe processing
   - UnsharpMask filter for image enhancement
   - WebP format for better compression
   - Eager loading for above-the-fold images
   - Fill command with dimensions and positioning

3. Front matter structure:
   ```yaml
   coverImage: "images/example.png"
   ```

## Slider Functionality

The slider functionality has been refactored to dynamically pull images from the front matter of product pages. It only displays when the page type is "product" and images are defined. This enhances flexibility and maintainability of the slider component.

## File Naming Conventions
- Content files: lowercase with hyphens (e.g., `product-name.md`)
- Template partials: lowercase with hyphens
- Asset files: descriptive names matching Carrd structure

## Best Practices
1. Maintain design consistency with Carrd template
2. Optimize all images and assets for performance
3. Ensure responsive design works on all devices
4. Follow semantic HTML structure
5. Implement proper meta tags for SEO
6. Use appropriate caching strategies
7. Follow server restart policy:
   - Only restart the Hugo server when necessary (system changes or error fixes)
   - Rely on Hugo's live reload for content and style changes
   - Minimize unnecessary server restarts for efficient development
8. Use Tailwind utility classes for consistent styling
9. Keep FAQ data in content frontmatter, not in global configuration
10. Use double quotes in YAML only when needed (for values with spaces or special characters)
11. Run Tailwind build before deploying to ensure latest CSS changes are included

## Deployment
The site is deployed to Netlify with the following configuration:

1. **Build Command**: `hugo --gc --minify`
2. **Publish Directory**: `public`
3. **Hugo Version**: 0.140.2
4. **Domain**: nutcrackerpro.netlify.app
5. **Configuration File**: `netlify.toml`

### Deployment Process
1. Push changes to the GitHub repository
2. Netlify automatically builds and deploys the site
3. Form submissions are handled by Netlify Forms

## Schema.org Implementation
The site uses a modular Schema.org implementation for structured data:

1. **Base Schema Types** (always included):
   - Website schema
   - Organization schema

2. **Page-Specific Schema Types**:
   - Homepage: WebPage + FAQ (if present)
   - Product pages: WebPage + Product + FAQ (if present)
   - Article pages: WebPage + Article
   - About page: WebPage + AboutPage
   - Other pages: WebPage only

3. **Schema Partials**:
   - Each schema type has its own partial in `/layouts/partials/schema/`
   - FAQ schema only included when page has faq frontmatter
   - All schemas use dynamic data from page context

## Version Control
- `.gitignore` configured for Hugo
- Excludes:
  - `/public/`
  - `/resources/_gen/`
  - `/assets/jsconfig.json`
  - `hugo_stats.json`
  - `.hugo_build.lock`
  - `.DS_Store`

## Future Considerations
- SEO optimization
- Performance monitoring
- Analytics integration
- Social media integration
- Content delivery optimization
- Server-side caching strategies
- Automated asset optimization

## Support and Maintenance
For questions or issues:
- Check Hugo documentation: https://gohugo.io/documentation/
- Review project structure
- Consult this documentation file

## Communication Rules
- All communication regarding project updates, issues, and feature requests should be documented in the project management tool.
- Regular check-ins will be scheduled to discuss progress and address any blockers.
- Code reviews are mandatory for all new features or significant changes to ensure quality and maintainability.
- Documentation should be kept up to date with any changes made to the project to assist future developers and maintainers.
- Use clear and descriptive commit messages to document changes in the version control system.

Last Updated: 2025-02-22
