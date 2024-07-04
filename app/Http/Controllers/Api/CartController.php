<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Stores;
use App\Models\Product;
use App\Models\Carts_product;
use App\Models\Cart;
use App\Traits\CheckAuthForAdmin;

use Illuminate\Support\Facades\Validator;
class CartController extends Controller
{
    use CheckAuthForAdmin;

    public function index(Request $request)
    {
        

        // $cart=Cart::where('stores_id',$stores_id)->first();
        // $products=Carts_product::where('carts_id',$cart->id)->get();
        // return response()->json(['data'=>$products,'error'=>0]);


        
        ////this is away
        // $results= Stores::findOrFail($stores_id)->cart()->with('carts_products')->get();
        
        
        
        // //this is away

        // $results= Cart::where('stores_id',$stores_id)->first()->carts_products;
        

        // $res=array();
        // foreach($results as $product)
        // {
        //     $result=Product::findOrFail($product->product_id);
        //     array_push($res, array('product' => $result, 'amount' => $product->amount));
        // }
        // for($i=0;$i<40000000;$i++)
        // {

        // }
        $result=$this->authStore($request);
        if($result["status"]==true)
        {

            $results= Cart::where('stores_id',$result["store_id"])->first()->carts_products()->with('product')->get();
            return response()->json(['data'=>$results,'error'=>0],200);
        }


        
    }
    public function store(Request $request)
    {
        //عندما يقوم المستخدم باضافة المنتجات للسلة


        $validator = Validator::make($request->all(),
        [
            'product' => 'required|array',
            'product.*' => 'required|integer',
        ]);
        
        if ($validator->fails()) {
            // The validation failed
            $errors = $validator->errors()->all();
            return $errors;
            // Handle the errors as needed
        }
        $result=$this->authStore($request);
        if($result["status"]==true)
        {
            $stores=Stores::find($result['store_id']);
        if(empty($stores))
        {
            //not found
        return response()->json(['data'=>[],'error'=>5554,'message'=>'not found']);
        }
        $products=request('product');
        $cart_id=Cart::where('stores_id',$stores->id)->first()->id;
        $cart=Cart::where('stores_id',$stores->id)->first()->carts_products()->get();
        foreach ($products as $product) {
            //this condition to void repeate product in the same cart
        if($cart->contains('product_id', $product)==false)
            Carts_product::create([
            'carts_id'=>$cart_id,
            'product_id'=>$product
            ]);
        }
        return response()->json(['data'=>[],'error'=>0,'message'=>'products added to cart successfully'],201);
        }
        
    }



    public function update($stores_id)
    {
        //السماح للمستخدم بزيادة كمية المنتج الموجود بالسلة بمقدار واحد
        $validator = Validator::make(
        [
            'id' => $stores_id,
            'product'=>request('product'),
            'label'=>request('label'),
        ],
        [
            'id' => 'required|integer',
            'product' => 'required|integer',
            'label'=>'required|string'
        ]);
        
        if ($validator->fails()) {
            // The validation failed
            $errors = $validator->errors()->all();
            return $errors;
            // Handle the errors as needed
        }
        $stores=Stores::find($stores_id);
        if(empty($stores))
        {
            //not found
        return response()->json(['data'=>[],'error'=>5554,'message'=>'not found']);
        }
        $cart=Cart::where('stores_id',$stores->id)->first()->carts_products()->where('product_id',request('product'))->get();
        if( request('label')=="add")
        {
            $cart[0]->amount=$cart[0]->amount+1;
            $cart[0]->save();
        }
        else if(request('label')=="minus" && $cart[0]->amount>0)
        {
            $cart[0]->amount=$cart[0]->amount-1;
            $cart[0]->save();
        }
        // return  response()->json(['data'=>$cart]);
        // if(request('label')=="add")
        // {
        //     Carts_product::updateOrInsert(
        //         [
        //             'product_id' =>request('product'),
        //             'carts_id' => Cart::where('stores_id',$stores->id)->first()->id
        //         ],
        //         [
        //             'amount' => $cart[0]->amount+1,
        //         ]
        //     );
        // }
        // else if($cart[0]->amount>0){
        //     Carts_product::updateOrInsert(
        //         [
        //             'product_id' =>request('product'),
        //             'carts_id' => Cart::where('stores_id',$stores->id)->first()->id
        //         ],
        //         [
        //             'amount' => $cart[0]->amount-1,
        //         ]
        //     );
        // }




        return response()->json(['data'=>[],'error'=>0,'message'=>'product has updated successfully']);
    }
    public function destroy(Request $request)
    {
        
        $validator = Validator::make($request->all(),
        [
            'product' => 'required|integer',
        ]);
        
        if ($validator->fails()) {
            // The validation failed
            $errors = $validator->errors()->all();
            return $errors;
            // Handle the errors as needed
        }
        $result=$this->authStore($request);
        if($result["status"]==true)
        {
            $stores=Stores::findOrFail($result["store_id"]);
        if(empty($stores))
        {
            //not found
        return response()->json(['data'=>[],'error'=>5554,'message'=>'not found']);
        }
        $cart=Cart::where('stores_id',$stores->id)->first()->carts_products()->where('product_id',request('product'))->get();
        $cart[0]->delete();

        return response()->json(['data'=>[],'error'=>0,'message'=>'product has deleted successfully'],201);
        }
        else
        {
            return response()->json(['error'=>0,'message'=>'ليس لديك صلاحية'],404);
        }
        
    }
    public function removeProductsInCart(Request $request)
    {
        $result=$this->authStore($request);
        if($result["status"]==true)
        {
            $stores=Stores::findOrFail($result["store_id"]);
        if(empty($stores))
        {
            //not found
        return response()->json(['data'=>[],'error'=>5554,'message'=>'not found']);
        }
        $cart=Cart::where('stores_id',$stores->id)->first()->carts_products()->delete();

        return response()->json(['data'=>[],'error'=>0,'message'=>'successfully'],201);
        }
        else
        {
            return response()->json(['error'=>0,'message'=>'ليس لديك صلاحية'],404);
        }
    }
}
