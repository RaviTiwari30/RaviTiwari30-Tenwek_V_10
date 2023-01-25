<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SSIPreventionCheckList.aspx.cs" Inherits="Design_IPD_SSIPreventionCheckList" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <script type="text/javascript">
        $(document).ready(function () {
            bindCheckList();
        });
        function print()
        {
            var tid = '<%=Request.QueryString["TID"].ToString() %>';
            var pid = '<%=Request.QueryString["PID"].ToString() %>';
            window.open('./SSIPreventionCheckList_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID='+pid+'&TID='+tid+'');
        }

        var bindCheckList = function () {
            var tid='<%=Request.QueryString["TID"].ToString() %>';
            var pid='<%=Request.QueryString["PID"].ToString() %>';
            serverCall('SSIPreventionCheckList.aspx/BindCheckList', { TID: tid, PID: pid }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0)
                        {
                        //alert(responseData);
                        var str = '';
                        var select = '';
                        for (var i = 0; i < responseData.length; i++) {
                            str = '';

                            var row = responseData[i];
                            if (row.CheckListItemValue == '0') {
                                select = '<select class="CHECK"><option value="0" Selected>Select</option><option value="1">Yes</option><option value="2">No</option><option value="3">NA</option></select>';
                            }                               
                            else {
                                if (row.CheckListItemValue == '1') {
                                    select = '<select class="CHECK"><option value="0" >Select</option><option value="1" Selected>Yes</option><option value="2">No</option><option value="3">NA</option></select>';
                                }
                                else if (row.CheckListItemValue == '2') {
                                    select = '<select class="CHECK"><option value="0" >Select</option><option value="1">Yes</option><option value="2" Selected>No</option><option value="3">NA</option></select>';
                                }
                                else {                                   
                                    select = '<select class="CHECK"><option value="0" >Select</option><option value="1">Yes</option><option value="2">No</option><option value="3" Selected>NA</option></select>';
                                }
                            }
                            str += ' <td class="GridViewLabItemStyle" >' + (i + 1) + '<span style="display:none;" class="MID" >' + row.MID + '</span><span style="display:none;" class="CID" >' + row.CID + '</span></td>';
                            str += ' <td class="GridViewLabItemStyle" >' + row.TheBundle + '</td>';
                            str += ' <td class="GridViewLabItemStyle" >' + row.Criteria + '</td>';
                            str += ' <td class="GridViewLabItemStyle" >'+select+'</td>';
                            $("#tb_CheckList").append('<tr>' + str + '</tr>');
                        }
                }
                else {
                        modelAlert('No Data Available', function () {
                            
                    });
                    return;
                }
                }
            });
        }
        function prepareData() {
            var data = new Array();
            var Obj = new Object();
            jQuery("#tb_CheckList tr").each(function () {
                var id = jQuery(this).attr("id");

                var $rowid = jQuery(this).closest("tr");
                if ((id != "Header") ) {
                    Obj.CID = $rowid.find(".CID").text();
                    Obj.MID = $rowid.find(".MID").text();
                    Obj.CheckListItemID = $rowid.find(".MID").text();

                    Obj.CheckListItemValue = $rowid.find(".CHECK").val();
                    


                        //ObjIntake.Date = $("#txtDate").val();
                        //ObjIntake.Time = $rowid.find("#tdTime_Label").text();
                        data.push(Obj);
                        Obj = new Object();
                    
                }

            });
            return data;
        }
        var saveCheckList = function () {
            var tid = '<%=Request.QueryString["TID"].ToString() %>';
            var pid = '<%=Request.QueryString["PID"].ToString() %>';
            var data = prepareData();
            serverCall('SSIPreventionCheckList.aspx/SaveCheckList', { TID: tid, PID: pid,Data: data }, function (response) {

                var data=JSON.parse(response)
                if (data.status) {
                    //var responseData = JSON.parse(response);
                    modelAlert(data.message, function (response) {
                        location.reload();
                    });
                }
                });
            };


    </script>

    <form id="form2" runat="server">
        

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>SSI PREVENTION CHECK LIST </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                  
                </div>
                <div class="row">
                    <div class="col-md-24">
                     <table id="tb_CheckList"  class="FixedTables"  style="width:100%;">
                         <tr id="Header">
                             <th  class="GridViewHeaderStyle" scope="col" >Sr No</th>
                             <th class="GridViewHeaderStyle" scope="col" >THE BUNDLE</th>
                             <th class="GridViewHeaderStyle" scope="col" >CRITERIA</th>
                             <th class="GridViewHeaderStyle" scope="col" >YES/NO/NA</th>
                         </tr>
                     </table>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input  type="button" class="save" onclick="saveCheckList();" value="save"/>
                <input  type="button" class="save" onclick="print();" value="print"/>               
               </div>
        </div>
    </form>

</body>
</html>

