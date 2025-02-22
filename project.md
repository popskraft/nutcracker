# Nutcracker Project Documentation

## Project Overview
This is a Hugo-based website for Nutcracker products, converted from a Carrd template. The site is built with modern web standards and includes responsive design for optimal viewing across different devices. The primary focus is on product presentation and information delivery, with occasional embedded videos from YouTube or MP4 sources when needed.

## Technical Stack
- **Static Site Generator**: Hugo v0.140.2 (extended version)
- **Language**: Go Templates (Hugo), HTML5, CSS3
- **Design Source**: Carrd template conversion
- **Performance**: Optimized for maximum speed on all devices
- **Deployment**: Static hosting (specific platform TBD)

## Design Implementation
- Original design will be implemented from the Carrd template
- All styling and layout will match the existing design in `/carrd` directory
- Assets will be properly optimized for performance

## Project Structure
```
nutcracker/
├── archetypes/          # Content templates
├── assets/             # Process-needed assets (SASS, JS)
├── content/            # Main content directory
│   └── nitrile-gloves.md # Product content
├── data/              # Site data files
├── layouts/           # HTML templates
│   ├── _default/      # Default template files
│   │   ├── baseof.html # Base template
│   │   ├── list.html   # List template (video listing)
│   │   └── single.html # Single template (individual video)
│   └── partials/      # Template partials
│       ├── coverSlider.html # Slider partial
├── static/            # Static assets
│   ├── css/           # Stylesheets
│   │   └── main.css   # Main stylesheet
│   └── videos/        # Video files storage
└── themes/            # Theme directory (if using custom theme)
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
7. Minimize third-party dependencies

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

### Language Protocol
1. **User Communication**:
   - User will communicate in Russian language
   - All Russian input will be translated to English for development purposes
   - Translation will be optimized for technical and programming context

2. **Development Standards**:
   - All code will be written in English
   - All comments in code will be in English
   - All documentation will be maintained in English
   - All commit messages and technical discussions will be in English
   - Variable names, function names, and other code identifiers will use English

3. **Documentation**:
   - Project documentation will be maintained in English
   - Technical terms will use standard English programming terminology
   - Code examples will include English comments and explanations

This protocol ensures:
- Consistent codebase language
- Standard technical terminology
- Clear communication in development context
- Maintainable and understandable code for all developers

Last Updated: 2025-02-22
