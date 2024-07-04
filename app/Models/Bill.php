<?php

namespace App\Models;

use Illuminate\Contracts\Cache\Store;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Bill extends Model
{
    use HasFactory;
    protected $table = 'bill';
    public $timestamps = false;

    protected $fillable = [
        'created_at',
        'status',
        'country'
    ];
    public function orderitems():HasMany{
        return $this->hasMany(Orderitem::class,'bill_id','id');
    }
    public function store(){
        return $this->belongsTo(Stores::class,'stores_id','id');
    }
}
