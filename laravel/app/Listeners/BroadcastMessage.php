<?php

namespace App\Listeners;

use Laravel\Reverb\Events\MessageReceived;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class BroadcastMessage
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(MessageReceived $event): void
    {
        $message = json_decode($event->message, true);
        if (!array_key_exists('channel', $message) || !array_key_exists('data', $message) || !array_key_exists('event', $message)  || $message['event'] != 'chat') {
            return;
        }
        info('Message Received: ' . $message['data']['message']);
    }
}
