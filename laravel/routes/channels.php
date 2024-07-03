<?php

use Illuminate\Support\Facades\Broadcast;
use App\Models\User;

Broadcast::channel('all-chat', function (User $user) {
    return true;
});
