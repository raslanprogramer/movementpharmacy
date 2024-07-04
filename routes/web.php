<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CategoryController;
use App\Models\Stores;

use Illuminate\Support\Facades\DB;

Route::get('/', function () {
    return '<a href="http://192.168.0.114:8000/api/download-apk">Download APK</a>';
    
});


// Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
