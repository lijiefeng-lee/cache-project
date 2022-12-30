<?php
/**
 * Created by PhpStorm.
 * User: Sixstar-Peter
 * Date: 2019/12/11
 * Time: 22:10
 */

$redis=new \RedisCluster(null,["118.24.109.254:6390","118.24.109.254:6391","118.24.109.254:6392","118.24.109.254:6393"],$timeout = null, $readTimeout = null, $persistent = false,"sixstar");

$res=$redis->xAdd('mystream', "*", ['shop' => 'info']);

var_dump($redis->xRange('mystream', '-', '+'));

