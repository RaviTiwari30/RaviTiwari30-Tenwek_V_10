<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Design/MRD/FileHardCopyLocation.aspx.cs" Inherits="Design_MRD_FileHardCopyLocation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/ScrollableGrid.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
<script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
<script type="text/javascript" src="../../Scripts/shortcut.js"></script>

<script type="text/javascript">

    
    $(document).ready(function () {
        var MaxLength = 100;
        $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
            event.preventDefault();
        });
        $('#<%=txtRemarks.ClientID%>').bind("keypress", function (e) {
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            if (e.keyCode == 39 || keychar == "'") {
                return false;
            }

            if ($(this).val().length >= MaxLength) {

                if (window.event)//IE
                {
                    e.returnValue = false;
                    return false;
                }
                else//Firefox
                {
                    e.preventDefault();
                    return false;
                }

            }
        });
    });

 
    function ValidateDots() {
        if ($("#<%=txtAdditional.ClientID %>").val().charAt(0) == ".") {
            $("#<%=txtAdditional.ClientID %>").val('');
            return false;
        }
        if ($("#<%=txtSequence.ClientID %>").val().charAt(0) == ".") {
            $("#<%=txtSequence.ClientID %>").val('');
            return false;
        }
    }
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
        }
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            if ($find("mpopRack")) {
                $("#<%=txtAlmirah.ClientID %>").val('');
                $("#<%=cmbRoomPopUp.ClientID %>").prop("selectedIndex", 0);
                $("#<%=txtNoOfShelf.ClientID %>").val('');
                $("#<%=txtMaxNoRecord.ClientID %>").val('');
                $find("mpopRack").hide();
            }
            if ($find("mpe1")) {
                $find("mpe1").hide();
            }
            if ($find("mpe2")) {
                $("#<%=lblDocument.ClientID %>").text('');
                $("#<%=chkEdit.ClientID %>").attr('Checked', false);
                if ($("#<%=ddlDocument.ClientID %>").is(':visible')) {
                    $("#<%=ddlDocument.ClientID %>").prop("selectedIndex", 0);
                    $("#<%=ddlDocument.ClientID %>").hide();
                }
                $("#<%=txtDocument.ClientID %>").val('').show();
                $("#<%=txtSequence.ClientID %>").val('');
                //  $('#<%=ddlActive.ClientID %>').filter('[value="1"]').attr('checked', true);
                $('#<%=ddlActive.ClientID %>').val('1').attr('checked', true);
                $find("mpe2").hide();
            }
            if ($find("mpopLog")) {
                $find("mpopLog").hide();
            }
        }
    }
    function ClearRack() {
        $("#<%=txtAlmirah.ClientID %>").val('');
        $("#<%=cmbRoomPopUp.ClientID %>").prop("selectedIndex", 0);
        $("#<%=txtNoOfShelf.ClientID %>").val('');
        $("#<%=txtMaxNoRecord.ClientID %>").val('');
    }
    function validateRack() {
        if (typeof (Page_Validators) == "undefined") return;
        var Almirah = document.getElementById("<%=reqAlmirah.ClientID%>");
        var Room = document.getElementById("<%=reqRoom.ClientID%>");
        var Shelf = document.getElementById("<%=reqShelf.ClientID%>");
        var File = document.getElementById("<%=reqFile.ClientID%>");
        var LblName = document.getElementById("<%=lblMSGAlmirah.ClientID%>");
        ValidatorValidate(Almirah);
        if (!Almirah.isvalid) {
            LblName.innerText = Almirah.errormessage;
            return false;
        }

        ValidatorValidate(Room);
        if (!Room.isvalid) {
            LblName.innerText = Room.errormessage;
            return false;
        }
        ValidatorValidate(Shelf);
        if (!Shelf.isvalid) {
            LblName.innerText = Shelf.errormessage;
            return false;
        }
        ValidatorValidate(File);
        if (!File.isvalid) {
            LblName.innerText = File.errormessage;
            return false;
        }

    }
    function validateRoom() {
        if ($("#<%=btnRoom.ClientID %>").val() == "Save") {
            if ($("#<%=txtRoom.ClientID %>").val() == "") {
                $("#<%=lblMSGRoom.ClientID %>").text('Please Enter Room Name');
                alert('Please Enter Room Name');
                $("#<%=txtRoom.ClientID %>").focus();
                return false;
            }


        }
    }


</script>
<script type="text/javascript" >
    $(document).ready(function () {
        //  Sys.WebForms.PageRequestManager.getInstance().add_endRequest(validateDoc);
    });

    function validateDoc() {
        if ($("#<%=chkEdit.ClientID %>").is(':checked')) {
            if ($("#<%=ddlDocument.ClientID %> option:selected").text() == "Select") {
                $("#<%=lblDocument.ClientID %>").text('Please Select Document Name');
                return false;
            }
            if ($("#<%=txtDocument.ClientID %>").val() == "" || $("#<%=txtDocument.ClientID %>").val().length == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Document Name');
                $("#<%=txtDocument.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Valid Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }

        }
        else {
            if ($("#<%=txtDocument.ClientID %>").is(':visible') && $("#<%=txtDocument.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Document Name');
                $("#<%=txtDocument.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Valid Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
        }
    }
    function check(e) {
        var keynum
        var keychar
        var numcheck
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
        if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
            return false;
        }

        else {
            return true;
        }
    }
    function validatespaceDoc() {
        var Document = $('#<%=txtDocument.ClientID %>').val();
        if (Document.charAt(0) == ' ' || Document.charAt(0) == '.' || Document.charAt(0) == ',' || Document.charAt(0) == '0') {
            $('#<%=txtDocument.ClientID %>').val('');
            $("#<%=lblDocument.ClientID %>").text('First Character Cannot Be Space/Dot');
            Document.replace(Document.charAt(0), "");
            return false;
        }

    }
    function validatespaceRack() {
        var Rack = $('#<%=txtAlmirah.ClientID %>').val();
        if (Rack.charAt(0) == ' ' || Rack.charAt(0) == '.' || Rack.charAt(0) == ',' || Rack.charAt(0) == '0') {
            $('#<%=txtAlmirah.ClientID %>').val('');
            $("#<%=lblMSGAlmirah.ClientID %>").text('First Character Cannot Be Space/Dot');
            Rack.replace(Rack.charAt(0), "");
            return false;
        }
    }
    function validatespaceRoom() {
        var Room = $('#<%=txtRoom.ClientID %>').val();
        if (Room.charAt(0) == ' ' || Room.charAt(0) == '.' || Room.charAt(0) == ',' || Room.charAt(0) == '0') {
            $('#<%=txtRoom.ClientID %>').val('');
            $("#<%=lblMSGRoom.ClientID %>").text('First Character Cannot Be Space/Dot');
            Room.replace(Room.charAt(0), "");
            return false;
        }

    }
    function validateFile() {
        if (typeof (Page_Validators) == "undefined") return;
        var Room = document.getElementById("<%=reqFileRoom.ClientID%>");
        var Rack = document.getElementById("<%=reqRack.ClientID%>");
        var Shelf = document.getElementById("<%=Shelfreq.ClientID%>");
        var LblName = document.getElementById("<%=lblmainmsg.ClientID%>");
        // edited at 08-06-2017

        ValidatorValidate(Room);
        if (!Room.isvalid) {
            modelAlert(Room.errormessage);
            return false;
        }

        ValidatorValidate(Rack);
        if (!Rack.isvalid) {
            modelAlert(Rack.errormessage);
            return false;
        }
        ValidatorValidate(Shelf);
        if (!Shelf.isvalid) {
            modelAlert(Shelf.errormessage);
            return false;
        }
        if (Page_IsValid) {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        else {
            document.getElementById('<%=btnSave.ClientID%>').disabled = false;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
        }

    }
    $(document).ready(function () {
       
            var keycode = e.keyCode ? e.keyCode : e.which;
            var keynum
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            var keychar = String.fromCharCode(keynum)
            if ($(this).closest("tr").find("input[id*=txtQty]").val().charAt(0) == "0") {
                if (keycode >= "49" && keycode <= "57") {
                    $(this).closest("tr").find("input[id*=txtQty]").val(keychar);
                    return false;
                    
                }
            }

        });
  

  
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>

</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center">
                  <b>HardCopy Location</b><br/>
                 <asp:Label ID="lblmainmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
          
              <asp:ScriptManager ID="scripmanager1" runat="server">
                  
        </asp:ScriptManager>
            <div class="row">
            <div class="col-md-1"></div>
                <div class="col-md-22">
                  <div class="row"> 
                      <div class="col-md-3">
                         <label class="pull-left">Room</label>
                          <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                           <asp:DropDownList ID="cmbRoom" ToolTip="Select Room" runat="server"
                                     OnSelectedIndexChanged="cmbRoom_SelectedIndexChanged" AutoPostBack="true" TabIndex="1" CssClass="requiredField" ClientIDMode="Static">
                                </asp:DropDownList> 
                                <asp:RequiredFieldValidator ID="reqFileRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoom"
                        ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Room" Display="None"></asp:RequiredFieldValidator>
                       
                      </div>
                       <div class="col-md-3">
                         <label class="pull-left">Rack</label>
                          <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                           <asp:DropDownList ID="cmbAlmirah" runat="server" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged"
                                    AutoPostBack="true" ToolTip="Select Rack" TabIndex="2" CssClass="requiredField" ClientIDMode="Static">
                                </asp:DropDownList>
                                 <asp:RequiredFieldValidator ID="reqRack" SetFocusOnError="true" runat="server" ControlToValidate="cmbAlmirah"
                        ValidationGroup="SaveFile" InitialValue="Select" ErrorMessage="Please Select Rack" Display="None"></asp:RequiredFieldValidator>
                   
                      </div>
                      <div class="col-md-3">
                            <label class="pull-left">Shelf</label>
                            <b class="pull-right">:</b>
                              <asp:Label ID="lblFileId" runat="server" Visible="False" Text="Old FileNo. "></asp:Label><asp:Label
                            ID="lblCounter" runat="server" Font-Bold="True" style="display:none"></asp:Label>
                        </div>
                      <div class="col-md-5">
                          <asp:DropDownList ID="cmbShelf" runat="server" TabIndex="3" AutoPostBack="true"
                              OnSelectedIndexChanged="cmbShelf_SelectedIndexChanged" ToolTip="Select Shelf" CssClass="requiredField" ClientIDMode="Static">
                          </asp:DropDownList>
                          <asp:RequiredFieldValidator ID="Shelfreq" SetFocusOnError="true" runat="server" ControlToValidate="cmbShelf"
                              ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Shelf" Display="None"></asp:RequiredFieldValidator>

                      </div>
                  </div>  
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:TextBox ID="txtRemarks" TabIndex="4" ToolTip="Enter Remarks" runat="server"
                           style="padding:0px" TextMode="MultiLine" Height="40px"></asp:TextBox>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
        </div>
        
        
                
                <div class="POuter_Box_Inventory">
                      <div class="row" style="text-align:center">
                     <div class="col-md-24" style="text-align:center">
                      <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" CssClass="ItDoseButton" CausesValidation="false"
                ValidationGroup="SaveFile" TabIndex="5" ToolTip="Click to Save" OnClientClick="return validateFile();">
            </asp:Button>
                     <asp:Button ID="btnDoc" runat="server" ToolTip="Click to Create New Document" Visible="false" CssClass="ItDoseButton"
                            Text="Create New Document"  />
                    <asp:Button ID="btnCreateRoom" Text="Create New Room" CssClass="ItDoseButton"
                            runat="server" OnClick="btnCreateRoom_Click" ToolTip="Click to Create New Room " Visible="false" />
                    <asp:Button ID="btnCreateRack" Text="Create New Rack" CssClass="ItDoseButton"
                            runat="server" OnClick="btnCreateRack_Click" ToolTip="Click to Create New Rack" Visible="false" />
                   </div>
                     
                    </div>
            
        </div>
      
        
    </div>

        <div class="POuter_Box_Inventory" style="display:none;">

            <table>
                <tr>
                    <td align="right">
                        <%--For Additional Space in Shelf :&nbsp;--%>
                    </td>
                    <td>
                        <asp:TextBox ID="txtAdditional" runat="server" Width="147px" Style="display: none;"
                            MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDots()"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="fteAdditional" runat="server" TargetControlID="txtAdditional"
                            ValidChars="." FilterMode="ValidChars" FilterType="Numbers, Custom">
                        </cc1:FilteredTextBoxExtender>
                        <asp:Label ID="lblcur" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblroomid" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblrackid" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblshelno" runat="server" Visible="false"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlFileNo" runat="server" Visible="False" Width="140px">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:Label ID="lblFileNo" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>

                    <td colspan="2"></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td style="text-align: left"></td>
                    <td></td>
                </tr>
            </table>
        </div>
       
    <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Style="display:none"  
          Width="440px">
        <div class="Outer_Box_Inventory">
            <div class="Purchaseheader">
                Room Master <span><em>Press esc to close</em></span></div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table>
                        <tr align="center">
                            <td colspan="4">
                                <asp:Label ID="lblMSGRoom" runat="server" CssClass="ItDoseLblError" />
                            </td>
                        </tr>
                       
                        
                        <tr>
                            <td colspan="2" style="text-align:right">
                                Room Name :
                            </td>
                            <td style="text-align: left; width:200px" class="style2">
                                <asp:TextBox ID="txtRoom" runat="server" Width="175px" ToolTip="Enter Room Name"  TabIndex="1" MaxLength="50" 
                                    onkeyup="validatespaceRoom();"></asp:TextBox>
                            </td>
                            <td >
                                <asp:Button ID="btnRoom" Text="Save" CssClass="sub-btn grn-btn" runat="server" OnClick="btnRoom_Click"
                                    ValidationGroup="doc" OnClientClick="return validateRoom();" TabIndex="2" ToolTip="Click to Save" />
                                <asp:Button ID="btnCancel" runat="server" TabIndex="3" Text="Close" CssClass="sub-btn red-btn" OnClick="btnCancel_Click"  ToolTip="Click to Close"/>
                            </td>
                        </tr>
                        <tr>
                            <td >
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center">
                                <asp:GridView ID="grdRoom" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    Font-Names="Verdana" Font-Size="10pt" OnRowCancelingEdit="grdRoom_RowCancelingEdit"
                                    OnRowEditing="grdRoom_RowEditing" OnRowUpdating="grdRoom_RowUpdating">
                                    <Columns>
                                        <asp:BoundField DataField="Name" HeaderText="Room Name">
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                            <ItemStyle CssClass="GridViewItemStyle" Width="250px" />
                                        </asp:BoundField>
                                        <asp:CommandField ShowEditButton="True" HeaderText="Edit">
                                            <ItemStyle ForeColor="Maroon" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:CommandField>
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRoom_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"RmID") %>'
                                                    Visible="False"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <HeaderStyle CssClass="col_1" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="col_2" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowCancelingEdit" />
                    <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowEditing" />
                    <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowUpdating" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlRack" runat="server" CssClass="pnlItemsFilter" Style="width: 480px;display:none;">
        <div id="Div1" runat="server" class="Purchaseheader">
            Rack Master <span>Press esc to close</span> 
        </div>
        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
            <ContentTemplate>
        <table>
            <tr>
                <td class="auto-style2" style="width:400px">
                    <asp:RadioButtonList ID="rbtnAlmirah" runat="server" AutoPostBack="True" Enabled="true" OnSelectedIndexChanged="rbtnAlmirah_SelectedIndexChanged" RepeatDirection="Horizontal">
                        <asp:ListItem Selected="True" Value="0">Add New
                        </asp:ListItem>
                        <asp:ListItem Value="1">Edit</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
                <td>
                   <%-- <asp:CheckBox ID="editprerack" runat="server" OnCheckedChanged="editprerack_CheckedChanged" Text="Edit Previous Data" />--%>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="3">
                    <asp:Label ID="lblMSGAlmirah" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    Room :&nbsp;<span class="red-star">*</span>
                </td>
                <td>
                    <asp:DropDownList ID="cmbRoomPopUp" runat="server" Width="200px" TabIndex="2" ToolTip="Select Room" AutoPostBack="true" OnSelectedIndexChanged="cmbRoomPopUp_SelectedIndexChanged">
                    </asp:DropDownList>
                    
                    <asp:RequiredFieldValidator ID="reqRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoomPopUp"
                        ValidationGroup="SaveRack" InitialValue="0" ErrorMessage="Select Room" Display="None"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 200px">
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom"
                        ValidChars="0123456789" TargetControlID="txtMaxNoRecord">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    Rack Name :&nbsp;<span class="red-star">*</span
                </td>
                <td>
                    <asp:DropDownList ID="ddlrackname" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlrackname_SelectedIndexChanged" TabIndex="2" ToolTip="Select Rack" Width="200px">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtAlmirah" runat="server" AutoCompleteType="Disabled" MaxLength="50" onkeyup="validatespaceRack();"  ToolTip="Enter Rack Name" Width="195px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqAlmirah" runat="server" ControlToValidate="txtAlmirah" Display="None" ErrorMessage="Enter Rack Name" SetFocusOnError="true" ValidationGroup="SaveRack"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <td></td>
                    <td></td>
                </td>
            </tr>
            
            <tr>
                <td class="auto-style2">
                   No. Of Shelf  :&nbsp;<span class="red-star">*</span
                </td>
                <td>
                    <asp:TextBox ID="txtNoOfShelf" runat="server" TabIndex="3" ToolTip="Enter No. of Shelf"
                        Width="195px" MaxLength="5" AutoCompleteType="Disabled"></asp:TextBox>
                    
                    <asp:RequiredFieldValidator ID="reqShelf" SetFocusOnError="true" runat="server" ControlToValidate="txtNoOfShelf"
                        ValidationGroup="SaveRack" ErrorMessage="Enter No. Of Shelf" Display="None"></asp:RequiredFieldValidator>
                </td>
                <td>
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom"
                        ValidChars="0123456789" TargetControlID="txtNoOfShelf">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                </td>
                <td>
                </td>
                <td></td>
            </tr>
            <tr>
                <td>
                    Maximum No. of Files Per Shelf :&nbsp;<span class="red-star">*</span
                </td>
                <td>
                    <asp:TextBox ID="txtMaxNoRecord" runat="server" AutoCompleteType="Disabled" MaxLength="5" TabIndex="4" ToolTip="Enter Maximum No. of Files Per Shelf" Width="195px"></asp:TextBox>
                    
                    <asp:RequiredFieldValidator ID="reqFile" runat="server" ControlToValidate="txtMaxNoRecord" Display="None" ErrorMessage="Enter  Maximum No. of Files Per Shelf" SetFocusOnError="true" ValidationGroup="SaveRack"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <td>
                        <asp:Button ID="btnAlmirah" runat="server" CssClass="sub-btn grn-btn" OnClick="btnAlmirah_Click" OnClientClick="return validateRack();" TabIndex="5" Text="Save" ToolTip="Click to Save" ValidationGroup="SaveRack" />
                        <asp:Button ID="btnCancelRack" runat="server" CssClass="sub-btn red-btn" OnClick="btnCancelRack_Click" TabIndex="6" Text="Close" ToolTip="Click to Close" />
                    </td>
                    <td>&nbsp; </td>
                </td>
            </tr>
        </table>
                </ContentTemplate>
            <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="rbtnAlmirah" EventName="SelectedIndexChanged" />
           
                 <asp:AsyncPostBackTrigger ControlID="ddlrackname" EventName="SelectedIndexChanged" />
                    
                </Triggers>
            </asp:UpdatePanel>
        <br />
    </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none;">
        <div class="Purchaseheader">
            Document Master  <span><em >Press esc to close</em></span></div>
        <div>
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <table>
                        <tr align="center">
                            <td colspan="2">
                                <asp:Label ID="lblDocument" runat="server" CssClass="ItDoseLblError" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkEdit" runat="server" Text=" Is Edit" Font-Bold="True" OnCheckedChanged="chkEdit_CheckedChanged"
                                    AutoPostBack="true" />
                            </td>
                           
                        </tr>
                        <tr>
                            <td>
                                Document Name :
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDocument" runat="server" Width="100%" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlDocument_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtDocument" runat="server" AutoCompleteType="Disabled" MaxLength="50"
                                    onkeyup="validatespaceDoc();"
                                    panel2=""></asp:TextBox>
                                <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Sequence No. :&nbsp;
                            </td>
                            <td>
                                <asp:TextBox ID="txtSequence" runat="server" Width="30px" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)"
                                    onkeyup="ValidateDots()" AutoCompleteType="Disabled"></asp:TextBox>
                                <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <cc1:FilteredTextBoxExtender ID="fEarn1" runat="server" TargetControlID="txtSequence"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>Status</td>
                            <td style="text-align: center;">
                                <asp:RadioButtonList ID="ddlActive" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                    <asp:ListItem Value="0">Deactive</asp:ListItem>
                                </asp:RadioButtonList>
                                
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center"> <asp:CheckBox ID="chkMandatory" runat="server" Text=" Is Mandatory" Font-Bold="True"/>
                                <asp:Button ID="btnSave2" OnClientClick="return validateDoc();" runat="server" Text="Save"
                                    OnClick="btnSave2_Click" ToolTip="Click to Save" CssClass="sub-btn grn-btn" />
                                <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="sub-btn red-btn"
                                    OnClick="btnCancel1_Click" ToolTip="Click to Close" /></td>
                        </tr>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnSave2" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnCancel1" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="chkEdit" EventName="CheckedChanged" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </asp:Panel>
        <asp:Panel ID="pnlLog" runat="server"  CssClass="pnlItemsFilter" Style="display: none;border:5px solid rgb(150, 147, 147); ">
             <div class="Purchaseheader">
            Location Log  <span><em >Press esc to close</em></span>
        </div>
            <div class="table-responsive table-cont">
                <asp:GridView runat="server" ID="grdfileLog">
                    
                </asp:GridView>
                <div class="sub-btns">
                      <asp:Button ID="Button1" OnClick="Button1_Click" runat="server" Text="Close" CssClass="sub-btn red-btn" 
                TabIndex="5" ToolTip="Click to close" >
            </asp:Button>
                    </div>
            </div>
        </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnMClose" PopupControlID="Panel2"
        TargetControlID="btnDoc" X="510" Y="12" BehaviorID="mpe2">
    </cc1:ModalPopupExtender>
    <cc1:ModalPopupExtender ID="mpe1" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnMClose" PopupControlID="Panel1"
        TargetControlID="btn1" X="425" Y="10" BehaviorID="mpe1">
    </cc1:ModalPopupExtender>
    <cc1:ModalPopupExtender ID="mpopRack" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelRack" PopupControlID="pnlRack"
        TargetControlID="btn2" X="450" Y="10" BehaviorID="mpopRack" OnCancelScript="ClearRack();">
    </cc1:ModalPopupExtender>
        <cc1:ModalPopupExtender ID="mpopLog" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelRack" Drag="true"  PopupControlID="pnlLog"
        TargetControlID="btnLogClose" X="50" Y="10" BehaviorID="mpopLog" OnCancelScript="">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/>
        <asp:Button ID="btnMClose" runat="server" CssClass="ItDoseButton"/>
        <asp:Button ID="btn2" runat="server" CssClass="ItDoseButton"/>
        <asp:Button ID="btnLogClose" runat="server" CssClass="ItDoseButton"/>

    </div>
    </form>
</body>
</html>
