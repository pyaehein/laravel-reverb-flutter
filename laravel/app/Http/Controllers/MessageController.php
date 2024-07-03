<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function send(Request $request)
    {
        $message = $request->input('message');
        MessageSent::dispatch($message);
        return response()->json(['status' => 'Message Sent!']);
    }
}
