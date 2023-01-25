<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AddFreezer.aspx.cs" Inherits="Design_Mortuary_AddFreezer" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindFloor();
            bindFreezer();

            $("#txtDescription,#txtRackName").keypress(function (e) {
                var keynum
                var keychar
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                //List of special characters you want to restrict

                if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                    return false;
                }
                else {
                    return true;
                }
            });
            //,#txtRackNo
            $("#txtShelfNo,#txtRoomNo").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            });
        });


        function bindFloor() {
            $("#ddlFloor").empty();
            $.ajax({
                url: "../common/CommonService.asmx/bindFloor",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        var Floor = $.parseJSON(result.d);
                        $("#ddlFloor").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < Floor.length; i++) {
                            $("#ddlFloor").append($("<option></option>").val(Floor[i].Name).html(Floor[i].Name));
                        }
                    }
                    else {
                        $("#ddlFloor").append($("<option></option>").val("0").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindFreezer() {
            $.ajax({
                url: "Services/Mortuary.asmx/bindFreezer",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d != "0") {
                        FreezerResult = $.parseJSON(result.d);
                        var HtmlOutput = $("#FreezerScript").parseTemplate(FreezerResult);
                        $("#divFreezerDetails").html(HtmlOutput);
                        $("#divDetails,#divFreezerDetails").show();
                    }
                    else {
                        $("#divFreezerDetails").empty();
                        $("#divDetails,#divFreezerDetails").hide();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
    </script>
    <script type="text/javascript">

        function Validate() {
            $("#lblErrorMsg").text("");

            if ($("#ddlFloor").val() == "0") {
                $("#lblErrorMsg").text("Please Select Floor");
                $("#ddlFloor").focus();
                return false;
            }
            else if ($.trim($("#txtRoomNo").val()) == "") {
                $("#lblErrorMsg").text("Please Enter Room Number");
                $("#txtRoomNo").focus();
                return false;
            }
            else if ($.trim($("#txtRackName").val()) == "") {
                $("#lblErrorMsg").text("Please Enter Rack Name");
                $("#txtRackName").focus();
                return false;
            }
            else if ($.trim($("#txtRackNo").val()) == "") {
                $("#lblErrorMsg").text("Please Enter Rack Number");
                $("#txtRackNo").focus();
                return false;
            }
            else if ($.trim($("#txtShelfNo").val()) == "") {
                $("#lblErrorMsg").text("Please Enter Shelf Number");
                $("#txtShelfNo").focus();
                return false;
            }

            return true;
        }

        function GetFreezer() {

            var dataFreezer = new Array();
            var Freezer = new Object();

            Freezer.ID = $("#FreezerID").text();
            Freezer.Floor = $("#ddlFloor").val();
            Freezer.Room_No = $.trim($("#txtRoomNo").val());
            Freezer.RackName = $.trim($("#txtRackName").val());
            Freezer.Rack_No = $.trim($("#txtRackNo").val());
            Freezer.ShelfNo = $.trim($("#txtShelfNo").val());
            Freezer.Description = $.trim($("#txtDescription").val());
            Freezer.IsMuslim = $("#rblMuslim input[type='radio']:checked").val();
            Freezer.IsActive = $("#rblActive input[type='radio']:checked").val();
            dataFreezer.push(Freezer);

            return dataFreezer;
        }

        function SaveFreezer() {

            if (Validate() == true) {

                var dataFreezer = GetFreezer();

                $("#btnSave").val("Submitting...");
                $("#btnSave").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/SaveFreezer",
                    data: JSON.stringify({ Freezer: dataFreezer }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d == "2") {
                            $("#lblErrorMsg").text("Shelf Already Exist");
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                        }
                        else if (result.d == "1") {
                            Clear();
                            bindFreezer();
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            DisplayMsg('MM01', 'lblErrorMsg');
                        }
                        else if (result.d == "0") {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            DisplayMsg('MM05', 'lblErrorMsg');
                            bindFreezer();
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSave").val("Save");
                        $("#btnSave").attr("disabled", false);
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            }
        }

        function UpdateFreezer() {

            if (Validate() == true) {

                var dataFreezer = GetFreezer();

                $("#btnUpdate").val("Updating...");
                $("#btnUpdate").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/UpdateFreezer",
                    data: JSON.stringify({ Freezer: dataFreezer }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d == "1") {
                            Clear();
                            bindFreezer();
                            $("#FreezerID").text("0");
                            $("#btnUpdate").val("Update");
                            $("#btnUpdate").attr("disabled", false);
                            DisplayMsg('MM02', 'lblErrorMsg');
                            $("#btnSave").show();
                            $("#btnUpdate").hide();
                        }
                        else if (result.d == "0") {
                            $("#btnUpdate").val("Update");
                            $("#btnUpdate").attr("disabled", false);
                            DisplayMsg('MM05', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnUpdate").val("Update");
                        $("#btnUpdate").attr("disabled", false);
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            }
        }

        function EditFreezer(rowID) {
            $("#lblErrorMsg").text("");
            var row = $(rowID).closest("tr");
            $("#FreezerID").text(row.find("#tdID").text());
            $("#ddlFloor").val(row.find("#tdFloor").text());
            $("#txtRoomNo").val(row.find("#tdRoomno").text());
            $("#txtRackName").val(row.find("#tdRackName").text());
            $("#txtRackNo").val(row.find("#tdRackNo").text());
            $("#txtShelfNo").val(row.find("#tdShelfNo").text());
            $("#txtDescription").val(row.find("#tdDescription").text());
            $("#rblMuslim input[value='" + (row.find("#tdMuslim").text() == "Yes" ? "1" : "0") + "']").attr("checked", true);
            $("#rblActive input[value='" + (row.find("#tdStatuse").text() == "Yes" ? "1" : "0") + "']").attr("checked", true);
            $("#btnSave").hide();
            $("#btnUpdate").show();
        }

        function Clear() {
            $("#ddlFloor").val("0");
            $("#txtRoomNo").val("");
            $("#txtRackName").val("");
            $("#txtRackNo").val("");
            $("#txtShelfNo").val("");
            $("#rblMuslim input[value='0']").attr("checked", true);
            $("#txtDescription").val("");
            $("#rblActive input[value='1']").attr("checked", true);
        }
    </script>
    <script type="text/javascript">
        function validateFloor() {
            if ($.trim($("#txtFloorName").val()) == "") {
                $("#lblFloor").text('Please Enter Floor');
                $("#txtFloorName").focus();
                return false;
            }

        }
        function cancelFloor() {
            $("#txtFloorName").val('');
            $("#lblFloor").text('');
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Add Rack</span></b><br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Rack Information
            </div>
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlFloor" class="requiredField" style="width: 179px;" title="Select Floor" tabindex="1"></select>
                            <span id="FreezerID" style="display:none;">0</span>
                            <asp:Button ID="btnAddnewFloor" Text="New" runat="server" CssClass="ItDoseButton"
                            ToolTip="Click To Add New Floor" TabIndex="11"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" class="requiredField" id="txtRoomNo" title="Enter Room No" maxlength="10"  tabindex="2"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rack Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" class="requiredField" id="txtRackName" maxlength="20" title="Enter Rack Name"  tabindex="3"/>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rack No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtRackNo" class="requiredField"   maxlength="20" title="Enter Rack No."  tabindex="4"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Shelf No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" class="requiredField" id="txtShelfNo" maxlength="10" title="Enter Shelf No."  tabindex="5"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                For Muslim
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rblMuslim" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" TabIndex="6">
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <textarea id="txtDescription" style="height: 50px; resize: none;" cols="1" rows="1" title="Enter Description" maxlength="500" tabindex="7"></textarea>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:RadioButtonList ID="rblActive" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" TabIndex="8">
                                <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="0">De-Active</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="SaveFreezer();" tabindex="9"/>
            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" onclick="UpdateFreezer();" style="display:none;" tabindex="10"/>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="divDetails">
            <div class="Purchaseheader">
                Rack Details
            </div>
            <div id="divFreezerDetails">
            </div>
        </div>
    </div>
     <asp:Panel ID="pnlFloor" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; height: 116px">
        <div id="Div1" class="Purchaseheader" runat="server">
            Add New Floor
        </div>
        <table>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblFloor" ClientIDMode="Static" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Floor Name :&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtFloorName" CssClass="requiredField" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="100" Width="250px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Sequence No. :&nbsp;</td>
                <td>
                    <asp:DropDownList ID="ddlSequenceNo" runat="server">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                    </asp:DropDownList></td>
                <td style="text-align: left">&nbsp;</td>
            </tr>
        </table>
        <div class="filterOpDiv">
            <asp:Button ID="btnSaveFloor" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSaveFloor_Click" OnClientClick="return validateFloor();"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelFloor" runat="server" Text="Cancel" CssClass="ItDoseButton"></asp:Button>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpFloor" BehaviorID="mpFloor" runat="server" CancelControlID="btnCancelFloor" DropShadow="true"
        TargetControlID="btnAddnewFloor" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlFloor"
        PopupDragHandleControlID="Div1" OnCancelScript="cancelFloor()">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>&nbsp;

    <!--Freezer details-->
    <script type="text/html" id="FreezerScript">
        <table cellspacing="0" rules="all" style="width:100%" border="1" style="border-collapse:collapse;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>               	
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rack Name</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Rack No</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Shelf No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Floor</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Room No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Description</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">For Muslim</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Active</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none;">ID</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Edit</th>                                   	
		    </tr>
		    <#       
		    var dataLength=FreezerResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;
            var strStyle="";   
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = FreezerResult[j];               
		    #>
				    <tr>                               
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                        
                        <td class="GridViewLabItemStyle" id="tdRackName" style="width:80px;text-align:center; "><#=objRow.RackName#></td>    
					    <td class="GridViewLabItemStyle" id="tdRackNo" style="width:60px;text-align:center; "><#=objRow.Rack_No#></td>
					    <td class="GridViewLabItemStyle" id="tdShelfNo" style="width:60px;text-align:center;"><#=objRow.ShelfNo#></td>
                        <td class="GridViewLabItemStyle" id="tdFloor"  style="width:80px;text-align:center;" ><#=objRow.Floor#></td>
					    <td class="GridViewLabItemStyle" id="tdRoomno"  style="width:70px;text-align:center;" ><#=objRow.Room_No#></td>
					    <td class="GridViewLabItemStyle" id="tdDescription" style="width:150px;text-align:center"><#=objRow.Description#></td>
					    <td class="GridViewLabItemStyle" id="tdMuslim" style="width:80px;text-align:center;"><#=(objRow.IsMuslim==1?"Yes":"No")#></td>
					    <td class="GridViewLabItemStyle" id="tdStatuse" style="width:50px;text-align:center;"><#=(objRow.IsActive==1?"Yes":"No")#></td>                                                                  
                        <td class="GridViewLabItemStyle" id="tdID" style="width:20px;text-align:left;display:none;"><#=objRow.ID#></td>                                                                  
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                            <img id="imgView" src="../../Images/edit.png" style="cursor:pointer;" title="Click To View" onclick="EditFreezer(this);"/>
                        </td>                       
                    </tr>              
		    <#}        
		    #> 
	    </table>    
    </script>

</asp:Content>


