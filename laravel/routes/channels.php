<?php

use Illuminate\Support\Facades\Broadcast;
use App\Models\User;

Broadcast::channel('all-chat', function (User $user) {
    info('User ' . $user->id . ' is listening to all-chat');
    return true;
});
