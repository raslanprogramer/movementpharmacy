<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('admins')->insert([
            [
                'name' => 'Mohammed',
                'phone' => '12345678',
                'password' => '12345678',
                'rolls_id' => 1,//means it is super admin
                'country' => 0,
                'token' => null,
            ],
            [
                'name' => 'Mhmood',
                'phone' => '11',
                'password' => '11',
                'rolls_id' => 2,//means he is country_manager in the country
                'country' => 0,//country
                'token' => null,
            ],
            [
                'name' => 'Omer',
                'phone' => '10',
                'password' => '10',
                'rolls_id' => 3,//means he is delivery in the country
                'country' => 1,//anthor countery ,you can imagin that 0->Yemen and 1->Suadi Arabia
                'token' => null,
            ],
            // Add more admin users as needed
        ]);
    }
}
