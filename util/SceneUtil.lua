SceneUtil = {}

function SceneUtil.SyncLoad(scene)
	SceneManagement.SceneManager.LoadScene(scene)
end

function SceneUtil.AsyncLoad(scene)
	SceneManagement.SceneManager.LoadLevelAsync(scene)
end