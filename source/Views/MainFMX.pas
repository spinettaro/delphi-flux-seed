unit MainFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.TabControl, FMX.ScrollBox,
  FMX.Memo, FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Calendar, FMX.DateTimeCtrls,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.Components, EventBus.Commons, Dispatcher.Flux,
  DelphiFlux.ActionCreators, DelphiFlux.Stores;

type
  TMainForm = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    AniIndicator1: TAniIndicator;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    TabItem2: TTabItem;
    WelcomeLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FWaitMode: Boolean;
    FDispatcher: IFluxDispatcher;
    FSeedActionsCreators: ISeedActionsCreators;
    FStore: ISeedStore;
    procedure RedrawView;
    procedure InitializeFluxDependencies;
  public
    { Public declarations }
    [Subscribe(TThreadMode.Main)]
    procedure OnSeedStoreChange(AEvent: TSeedStoreChanged);
    [Subscribe(TThreadMode.Main)]
    procedure OnLoadingEvent(AEvent: TLoadingEvent);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  RedrawView;
  FSeedActionsCreators.DoLogin(Edit1.Text, Edit2.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem1;
  InitializeFluxDependencies;
  RedrawView;
end;

procedure TMainForm.InitializeFluxDependencies;
begin
  // FLUX
  FDispatcher := GetDispatcher;
  FSeedActionsCreators := GetSeedActionsCreators(FDispatcher);
  FStore := GetSeedStore(FDispatcher);
  FDispatcher.Register(Self);
  FDispatcher.Register(TSeedStore(FStore));
end;

procedure TMainForm.OnLoadingEvent(AEvent: TLoadingEvent);
begin
  try
    FWaitMode := AEvent.Wait;
    RedrawView;
  finally
    AEvent.Free;
  end;
end;

procedure TMainForm.OnSeedStoreChange(AEvent: TSeedStoreChanged);
begin
  try
    WelcomeLabel.Text := WelcomeLabel.Text + ' ' +
      FStore.GetCurrentUser.Username;
    TabControl1.SetActiveTabWithTransition(TabItem2, TTabTransition.Slide);
  finally
    RedrawView;
    AEvent.Free;
  end;
end;

procedure TMainForm.RedrawView;
begin
  Button1.Default := TabItem1.IsSelected;
  Button1.Enabled := not FWaitMode;
  AniIndicator1.Visible := FWaitMode;
  AniIndicator1.Enabled := FWaitMode;
  Rectangle1.Visible := FWaitMode;
end;

end.
