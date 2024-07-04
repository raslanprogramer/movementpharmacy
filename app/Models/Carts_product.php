<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class carts_product extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $table = 'carts_products';

    protected $fillable = [
        'carts_id',
        'product_id',
        'amount'
    ];
    protected $hidden=[
        'carts_id',
    ];
    public function product()
    {
        //ownerKey means the primaryKey in the father
        //foreignKey means the foreignKey of child,in this case the child is Product::class 
        return $this->belongsTo(Product::class,'product_id','id');
    }
}
