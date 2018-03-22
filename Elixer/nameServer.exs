defmodule NameServer do
  use GenServer
 
  # Start Helper Functions (Don't Modify)
  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end
 
  def start() do
    GenServer.start(__MODULE__, [],  [])
  end
 
  def register(name_server, name) do
    GenServer.call(name_server, {:register, name})
  end
 
  def register(name_server, name, pid) do
    GenServer.cast(name_server, {:register, name, pid})
  end
 
  def resolve(name_server, name) do
    GenServer.call(name_server, {:resolve, name})
  end
  #End Helper Functions
 
 
 
  def init(_) do
    #This would be a good place to start a new data structure for keeping pid names
	localMap = Map.new()
	{:ok, localMap}
  end
 
  def handle_call({:register, name}, {pid, _from}, localMap) do
 	#{:register, name} #This will register the given name with the callers pid and return the caller :ok
	#Synchronous    
	#Change the parameter names appropriately
    
	{:reply, :ok, localMap}
 
  end
 
  def handle_call({:resolve, name}, {pid, _from}, localMap) do
 	#{:resolve, name} #This will return to the caller the pid associated with name, or :error if no such pid can be found
	#Asynchronous
	#Change the parameter names appropriately
    #Your code here
 
  end
 
  def handle_cast({:register, name, pid}, localMap) do
 	#{:register, name, pid} #register the given name to the given pid, no reply is expected
	#Asynchronous
	#Change the parameter names appropriately
    #Your code here
 
  end
 
 
 
 
  def handle_call(request, from, state) do
    super(request, from, state)
  end
 
  def handle_cast(request, state) do
    super(request, state)
  end
 
  def hande_info(_msg, state) do
    {:noreply, state}
  end
end