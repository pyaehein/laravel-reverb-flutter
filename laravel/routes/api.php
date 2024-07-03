<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/tokens/create', function (Request $request) {
    $user = \App\Models\User::inRandomOrder()->first();
    $token = $user->createToken($request->token_name);
    return ['token' => $token->plainTextToken];
});
