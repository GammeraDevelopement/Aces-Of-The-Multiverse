using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using AcesMultiverse;
using System.IO;
using UnityEditor;

public class JSONDataTest : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //_cardDataList = new List<CardData>();
        //Debug.Log(FileManager.Instance.ParseObjectToJson<GameDataInfo>(_gameData));
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            _gameData = FileManager.Instance.LoadDataText<GameDataInfo>(_gameDataFile.text);
        }
        else if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<CardDataListWrapper>(_cardDataList));
        }
        else if (Input.GetKeyDown(KeyCode.U))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<UserDataInfo>(_userData));
        }
        else if (Input.GetKeyDown(KeyCode.P))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<PresetDataListWrapper>(_presetDataList));
        }
        else if (Input.GetKeyDown(KeyCode.S))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<SoccerData>(_soccerData));
        }
        else if (Input.GetKeyDown(KeyCode.M))
        {
            _storyModeData = FileManager.Instance.LoadDataText<StoryModeData>(_storyModeDataFile.text);
        }
        else if (Input.GetKeyDown(KeyCode.N))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<StoryModeData>(_storyModeData));
        }
        else if (Input.GetKeyDown(KeyCode.G))
        {
            Debug.Log(FileManager.Instance.ParseObjectToJson<GameDataInfo>(_gameData));
        }
    }

    [SerializeField]
    private CardData _cardData;

    [SerializeField]
    private PresetDataListWrapper _presetDataList;

    [SerializeField]
    private UserDataInfo _userData;

    [SerializeField]
    private TextAsset _cardDataFile;

    [SerializeField]
    private CardDataListWrapper _cardDataList;

    [SerializeField]
    private SoccerData _soccerData;

    [SerializeField]
    private StoryModeData _storyModeData;

    [SerializeField]
    private GameDataInfo _gameData;

    [SerializeField]
    private TextAsset _gameDataFile;
    [SerializeField]
    private TextAsset _storyModeDataFile;
}
