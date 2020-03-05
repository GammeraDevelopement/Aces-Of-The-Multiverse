using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingPongMeteor : MonoBehaviour
{
    [SerializeField]
    [Range(-1f, 1f)]
    private float movementSpeed;
    [SerializeField]
    [Range(0.0f, 4.0f)]
    private float height;

    // Update is called once per frame
    void Update()
    {
        transform.position = new Vector3(transform.position.x, Mathf.Cos(Mathf.PingPong(Time.time/(1/movementSpeed), height)), transform.position.z);
    }
}
