defmodule TopSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
	  worker(Supervisor1, [ns]),
      worker(CustomerService, [ns]),
    ]
 
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Supervisor1 do
	use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Database, [ns]),
      worker(Supervisor2, [ns]),
      worker(Supervisor3, [ns]),
    ]
 
    supervise(children, strategy: :rest_for_one)
  end
end

defmodule Supervisor2 do
use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(User, [ns]),
      worker(Order, [ns])
    ]
 
    supervise(children, strategy: :one_for_all)
  end
end

defmodule Supervisor3 do
use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Info, [ns]),
      worker(Shipper, [ns]),
    ]
 
    supervise(children, strategy: :one_for_one)
  end
end