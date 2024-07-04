<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Product extends Model
{
    use HasFactory;
    protected $table = 'product';
    public $timestamps = false;

    protected $fillable = [
        'name',
        'img',
        'amount',
        'price',
        'category_id',
        'country',
    ];
    // public function category():BelongsTo
    // {
    //     return $this->belongsTo(Category::class);
    // }
}
