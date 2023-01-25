<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ThresholdMaster.aspx.cs"
    Inherits="Design_EDP_ThresholdMaster" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="aspx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            document.getElementById("Pbody_box_inventory").style.display = 'none';
        }
       
        function thresholdLimitSave() {
            $("#lblMsg").text('');
            if ($.trim($("#txtAmount").val()) === "") {
                $("#lblMsg").text('Please Enter Threshold Amount');
                $("#txtAmount").focus();
                return;
            }
            $.ajax({
                type: "POST",
                url: "Services/EDP.asmx/thresholdLimitSave",
                data: '{panelID:"' + $.trim($("#ddlPanel").val()) + '",thresholdAmount:"' + $.trim($("#txtAmount").val()) + '",Active:"' + $("#rbtActive input[type:radio]:checked").val() + '",type:"' + $.trim($("#btnSaveTh").val()) + '",RoomType:"' + $.trim($("#ddlRoomType").val()) + '",oldRoomID:"' + $.trim($("#oldRoomID").text()) + '",oldPanelID:"' + $.trim($("#oldPanelID").text()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    threshold = response.d;
                    if (threshold == "1") {
                        if ($("#btnSaveTh").val()=="Save")
                            DisplayMsg('MM01', 'lblMsg');
                        else
                            DisplayMsg('MM02', 'lblMsg');
                    }
                    else if (threshold == "2") {
                        $("#lblMsg").text('Already Threshold Limit Amount Exists');
                    }
                    else {
                        DisplayMsg('MM05', 'lblMsg');
                    }
                    Cancel();
                    thresholdLimitSearch();
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        $(document).ready(function () {
            thresholdLimitSearch();
        });
        function thresholdLimitSearch() {
            $.ajax({
                type: "POST",
                url: "Services/EDP.asmx/thresholdLimitSearch",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    thresholdLimit = jQuery.parseJSON(response.d);
                    if (thresholdLimit != null) {
                        var output = $('#tb_SearchthresholdLimit').parseTemplate(thresholdLimit);
                        $('#thresholdLimitOutput').html(output);
                        $('#thresholdLimitOutput').show();
                    }
                    else {
                        $('#thresholdLimitOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function editThreshold(rowid) {
            var ID = $(rowid).closest('tr').find('#tdID').text();
            var PanelID = $(rowid).closest('tr').find('#tdPanelID').text();
            var Amount = $(rowid).closest('tr').find('#tdAmount').text();
            var Status = $(rowid).closest('tr').find('#tdStatus').text();
 var RoomID = $(rowid).closest('tr').find('#tdRoomID').text();
 $('#oldRoomID').text(RoomID);
 $('#oldPanelID').text(PanelID);
            $("#txtAmount").val(Amount);
            $("#ddlPanel").val(PanelID);
            $("#ddlRoomType").val(RoomID);

            $("#btnSaveTh").val('Update');
            $("#btnCancel").show();

            if ($(rowid).closest('tr').find('#tdStatus').text() == "Active")
                $("#rbtActive").find('input:radio[value=1]').prop('checked', true);
            else
                $("#rbtActive").find('input:radio[value=0]').prop('checked', true);
        }

        function Cancel() {
            $("#txtAmount").val('');
            $("#ddlPanel").prop('selectedIndex', 0);
            $("#ddlRoomType").prop('selectedIndex', 0);
            $("#btnSaveTh").val('Save');
            $("#btnCancel").hide();
            $("#rbtActive").find('input:radio[value=1]').prop('checked', true);
            $('#oldRoomID').text('');
 $('#oldPanelID').text('');
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
   
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center">

                    <b>Set Minimum Threshold Limit (IPD)<br />
                    </b>
                    <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>

                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Threshold Details&nbsp;
                    </div>
                  
                        <table style="width: 70%;border-collapse:collapse"  border="0">
                            <tr>
                                <td style="width: 30%; text-align:right" >Panel :&nbsp;
                                </td>
                                <td style="width: 70%;text-align:left" >
                                    <asp:DropDownList ID="ddlPanel" runat="server" Width="185px" ClientIDMode="Static">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%; text-align:right" >Room Type :&nbsp;
                                </td>
                                <td style="width: 70%;text-align:left" >
                                      <asp:DropDownList ID="ddlRoomType" runat="server" Width="178px" ClientIDMode="Static">
                                    </asp:DropDownList>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="width: 30%; text-align:right" >Threshold Amount :&nbsp;
                                </td>
                                <td style="width: 70%; text-align:left" >
                                    <asp:TextBox ID="txtAmount" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" Width="178px" MaxLength="10"></asp:TextBox>
                                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                                    <cc1:FilteredTextBoxExtender ID="ftbAmount" runat="server" TargetControlID="txtAmount"
                                        FilterType="Numbers">
                                    </cc1:FilteredTextBoxExtender>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%; text-align:right" ></td>
                                <td style="width: 70%; text-align:left" >
                                    <asp:RadioButtonList ID="rbtActive" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                        <asp:ListItem Value="0">DeActive</asp:ListItem>
                                    </asp:RadioButtonList>
                                      <span id="oldRoomID" style="display:none"></span> </span><span id="oldPanelID" style="display:none"></span>
                                </td>
                            </tr>
                        </table>
                   
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center">
                    
                               
                    <input type="button" id="btnSaveTh" value="Save" class="ItDoseButton" onclick="thresholdLimitSave()" />
                              <input type="button" id="btnCancel" style=" display:none" value="Cancel" class="ItDoseButton" onclick="Cancel()" />
                </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
            <table border="0" style="width: 100%">
                 <tr>
                    
                    <td colspan="3">
    <div id="thresholdLimitOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
                 
     </td>
                </tr>
            

            </table>
                </div>
                 </div>
         <script id="tb_SearchthresholdLimit" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdErrorType"
    style="width:800px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Panel Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Room Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Threshold Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Status</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">ID</th>		          
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">PanelID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none  ">Room Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>           
		</tr>
        <#       
        var dataLength=thresholdLimit.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = thresholdLimit[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelName"  style="width:250px;text-align:center" ><#=objRow.PanelName#></td>
                        <td class="GridViewLabItemStyle" id="td1"  style="width:250px;text-align:center" ><#=objRow.RoomName#></td>
                    <td class="GridViewLabItemStyle" id="tdAmount"  style="width:200px;text-align:center" ><#=objRow.Amount#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus"  style="width:90px;" ><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:60px;display:none"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelID" style="width:60px;display:none"><#=objRow.PanelID#></td>
                        <td class="GridViewLabItemStyle" id="tdRoomID" style="width:60px;display:none"><#=objRow.Room_Type#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:right">
                        <input type="button" value="Edit"   id="btnEdit"  class="ItDoseButton" onclick="editThreshold(this);"                       
                            
                          />                                                    
                    </td>                    
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

</asp:Content>
