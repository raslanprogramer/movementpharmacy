<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Stores;
class StoresSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Stores::create([
            'name' => 'بقالة ركن التوفير',
            'phone' => '713754340',
            'password' => '1234',
            'location' => '13.5,13.6',
            'note' => 'خط الثلاثين خلف معرض الكويت الفكة الاولى',
            'country' => 0,
        ]);
        Stores::create([
            'name' => 'بقالة سمير المليكي',
            'phone' => '713754340',
            'password' => '1234',
            'location' => '13.5,13.6',
            'note' => 'خط الثلاثين خلف معرض الكويت الفكة الاولى',
            'country' => 0,
        ]);
    }
}
