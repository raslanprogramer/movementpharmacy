<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = [
        'stores_id',
    ];
    public function carts_products()
    {
        return $this->hasMany(Carts_product::class,'carts_id','id');
    }
}
