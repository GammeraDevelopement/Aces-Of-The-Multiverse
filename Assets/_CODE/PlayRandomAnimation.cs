using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayRandomAnimation : MonoBehaviour
{
    [SerializeField]
    private GameObject[] animableObjects;
    [SerializeField]
    private float waitTimeForNextAnim;
    private Animator[] animators = new Animator[5];

    private STATE _state;

    private int randomObject = 0;
    private float startingWaitTime = 1f;

    private float timer;

    public enum STATE {  IDLE = 0, LAUNCH_ANIMATION}

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < animableObjects.Length; i++)
        {
            animators[i] = animableObjects[i].GetComponent<Animator>();
        }
        _state = STATE.LAUNCH_ANIMATION;        
    }

    // Update is called once per frame
    void Update()
    {
        switch (_state)
        {
            case STATE.IDLE:
                break;

            case STATE.LAUNCH_ANIMATION:
                timer += Time.deltaTime;
                if (timer > startingWaitTime)
                {
                    int lastRandom = randomObject;
                    timer = 0;
                    randomObject = UnityEngine.Random.Range(0, animableObjects.Length);
                    while(randomObject == lastRandom)
                    {
                        randomObject = UnityEngine.Random.Range(0, animableObjects.Length);
                    }
                    Debug.Log("Current: " + randomObject);
                    Debug.Log("Last: " + lastRandom);
                    animators[randomObject].Play("MenuMovement");
                    startingWaitTime = UnityEngine.Random.Range(5f, 12f);
                }
                break;
        }

        //Debug.Log("Timer: " + timer);
    }

}
