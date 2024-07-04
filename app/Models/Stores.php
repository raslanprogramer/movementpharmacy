<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Stores extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $table = 'stores';
    protected $fillable = ['name', 'phone','password','location','note', 'country','token'];
    public function bills():HasMany
    {
        return $this->hasMany(Bill::class,'stores_id','id');
    }
    public function cart()
    {
        return $this->hasOne(Cart::class,'stores_id','id');
    }
}
