<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable=[
        'phone',
        'name',
        'password',
        'rolls_id',
        'country',
        'token'
    ];
    public function roll()
    {
        return $this->belongsTo(Roll::class,'rolls_id','id');
    }
}