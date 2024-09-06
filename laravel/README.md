## How to run laravel backend servers

### Note:
- These are only for development purposes
- For production, you should use a web server like Apache or Nginx and supervisor

Type artisan command to run the project
```bash
php artisan serve --host="0.0.0.0"
```

Type reverb start command to run the project (--debug is optional)
```bash
php artisan reverb:start --host="0.0.0.0" --debug
```
