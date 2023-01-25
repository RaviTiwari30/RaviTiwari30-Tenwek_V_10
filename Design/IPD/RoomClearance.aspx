<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoomClearance.aspx.cs" Inherits="Design_IPD_RoomClearance" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {

            $('#btnSave').bind('click', function (e) {

             var IsCheckListApplicable = '<%= Resources.Resource.NursingCheckListApplicable.ToString()%>';
                  var CheckListApplicableOn = '<%= Resources.Resource.NursingCheckListApplicableOn.ToString()%>';
                  var NursingClearanceId = '<%= (int)AllGlobalFunction.DischargeProcessStep.RoomClearance%>';
                  if (Number(IsCheckListApplicable) == 1 && Number(CheckListApplicableOn) == Number(NursingClearanceId)) {
                      e.preventDefault();
                      validateCheckList();
                  }
                  else
                      return true;
              });



          });
          var validateCheckList = function () {
              var TID = '<%= ViewState["TransactionID"].ToString() %>';
            serverCall('Services/IPD.asmx/getDischargeCheckList', { TID: TID }, function (response) {
                if (response != '') {
                    var $responseData = JSON.parse(response);
                    $('#divCheckListItems').empty();
                    $.each($responseData, function (i, v) {
                        $('#divCheckListItems').append('<div class="col-md-8" style="font-weight: bold;"><input type="checkbox" class="cbCheckList" />' + v.Item + '</div>');
                    });
                    $('#divCheckList').showModel();

                }
                else {
                    modelAlert('No Check List Item Mapped with the Room Type.', function () {
                        __doPostBack('btnSave', '');
                    });

                }
            });
        }
        var saveNursingClearance = function () {
            if ($('.cbCheckList:checked').length != $('.cbCheckList').length) {
                modelAlert('All the Items should be Checked.');
                return false;
            }
            __doPostBack('btnSave', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory" runat="server">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <b>Room Clearance</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="MainDiv" runat="server">
                <table style="width: 100%">
                    <tr>
                        <td colspan="4" style="text-align: center">
                            <asp:Button ID="btnSave" Text="Room Clearance" OnClick="btnSave_Click" CssClass="ItDoseButton" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="divCheckList" class="modal fade ">
            <div class="modal-dialog">
             <div class="modal-content" style="background-color: white; width: 700px; height: 153px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divCheckList" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Nurssing Check List</h4>
            </div>
            <div class="modal-body">
                <div class="row" id="divCheckListItems">
                    
                </div>
            </div>
            <div class="modal-footer" style="text-align:center;">
                <button type="button" onclick="saveNursingClearance()" style="width:100px;">Save</button>
            </div>
        </div>
    </div>
</div>
    </form>
</body>
</html>

