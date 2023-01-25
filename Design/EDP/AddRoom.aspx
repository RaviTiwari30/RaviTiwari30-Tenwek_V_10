<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="AddRoom.aspx.cs" Inherits="Design_EDP_AddRoom" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#chkBillingCategory').click(function () {
                if ($('#chkBillingCategory').attr('checked') == 'checked') {
                    $("#ddlBillingCategory").hide();
                }
                else {
                    $("#ddlBillingCategory").show();
                }
            });
        });

        function validateFloor(btn) {
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
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtDescription.ClientID %>,#<% =txtDesc.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtDescription.ClientID%>,#<% =txtDesc.ClientID %>').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
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

        function validateRoom(btn) {
            if ($.trim($("#txtRoomType").val()) == "") {
                $("#lblRoom").text('Please Enter Room Type');
                return false;
            }

            if ($("#cmbDept").val() == "0") {
                $("#lblRoom").text('Please Select Department');
                return false;
            }
            if ($("#ddlRevenueMap").val() == "0") {
                $("#lblRoom").text('Please Revenue Name');
                return false;
            }
        }

        function cancelRoom() {
            $("#lblRoom").text('');
        }

        function validateRoomType(btn) {
            if ($("#ddlCaseType").val() == "0") {
                $("#lblMsg").text('Please Select Room Type');
                $("#ddlCaseType").focus();
                return false;
            }

           

            // if ($.trim($("#txtName").val()) == "") {
            //   $("#lblMsg").text('Please Select Room Name');
            // $("#txtName").focus();
            //return false;
            // }
            //if ($.trim($("#txtRoomNo").val()) == "") {
            //  $("#lblMsg").text('Please Select Room No.');
            //$("#txtRoomNo").focus();
            //  return false;
            // }
        }
    </script>

    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server" EnablePartialRendering="true"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>&nbsp;Room Master</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Room Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                      <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                                Center Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlcenter" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Select Center" OnSelectedIndexChanged="ddlcenter_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                      </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCaseType" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Select Room Type"
                               AutoPostBack="True"
                                OnSelectedIndexChanged="ddlCaseType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-1">
                            <asp:Button ID="btnAddNew" Text="New" runat="server" CssClass="ItDoseButton"
                                ToolTip="Click To Add New Room Type" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" Width="95%" ToolTip="Enter Room Name"
                                TabIndex="2" MaxLength="20" class="requiredField" ></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRoomNo" AutoCompleteType="Disabled" Width="95%" ClientIDMode="Static" runat="server" TabIndex="3" ToolTip="Enter Room No."
                                MaxLength="50" class="requiredField"></asp:TextBox>
                           
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                              Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="cmbFloor" runat="server" ToolTip="Select Floor" 
                                TabIndex="4">
                            </asp:DropDownList>
                        </div>
                         <div class="col-md-1">
                            <asp:Button ID="btnAddnewFloor" Text="New" runat="server" CssClass="ItDoseButton"
                                ToolTip="Click To Add New Floor" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bed No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <asp:TextBox ID="txtBedNo" AutoCompleteType="Disabled" runat="server" Width="95%" 
                                ToolTip="Enter Bed No." MaxLength="50"  TabIndex="5"></asp:TextBox>
                        </div>
                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                Desc.(if any)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:TextBox ID="txtDescription" runat="server" Rows="3" TextMode="MultiLine" Width="100%"
                                TabIndex="6" ToolTip="Enter Description" Height="30px" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:RadioButtonList ID="rbtStatus" runat="server" RepeatDirection="Horizontal"
                                ToolTip="Select Active Or De-Active for Status">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">De-Active</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Share
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:RadioButtonList ID="rblDocShare" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                
                            </label>
                         
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsCount" runat="server" Text="Actual Bed"
                                    ToolTip="Check Actual Bed For Description" />
                        </div>
                    </div>
                  
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Save"
                ToolTip="Click For Save " TabIndex="7" CssClass="ItDoseButton" OnClientClick="return validateRoomType(this)" />

            &nbsp;&nbsp;&nbsp;<asp:Button ID="btnClear" runat="server" OnClick="btnClear_Click"
                Text="Clear" ToolTip="Click For Clear The Above Records"
                TabIndex="8" CssClass="ItDoseButton" />
        </div>

        <asp:Panel Visible="false" runat="server" ID="pnlRoomType">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Room Details&nbsp;
                </div>
                <asp:GridView ID="grdInv" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    PageSize="5" Width="100%" OnSelectedIndexChanged="grdInv_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room Type">
                            <ItemTemplate>
                                <%#Eval("RoomType")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room Name">
                            <ItemTemplate>
                                <%#Eval("NAME")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room No.">
                            <ItemTemplate>
                                <%#Eval("Room_No")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bed No.">
                            <ItemTemplate>
                                <%#Eval("Bed_No")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Floor">
                            <ItemTemplate>
                                <%#Eval("Floor")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <%#Eval("Description")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%#Eval("IsActive")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IsCount">
                            <ItemTemplate>
                                <%#Eval("IsCountable")%>
                                <asp:Label ID="lblIPDCaseType_Id" runat="server" Text='<%# Eval("IPDCaseTypeID") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblRoomID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"RoomID") %>'
                                    Visible="false"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:CommandField HeaderText="Edit" SelectText="Edit" ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/Images/edit.png">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>
    <asp:Panel ID="pnlSave" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" runat="server">
            Add New Room Type
        </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblRoom" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
            </tr>
            <tr>
                <td style="text-align: right">Room Type :&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtRoomType" runat="server" AutoCompleteType="Disabled"
                        MaxLength="100" Width="250px" ClientIDMode="Static"  class="requiredField" ></asp:TextBox>
                   
                               
                </td>
            </tr>
            <tr>
                <td style="text-align: right; vertical-align: top">Description :&nbsp;</td>
                <td>

                    <asp:TextBox ID="txtDesc" runat="server" Height="40px"
                        MaxLength="200" TextMode="MultiLine" Width="250px"></asp:TextBox>
                </td>
            </tr>

             <tr>
                <td style="text-align: right; vertical-align: top">Department :&nbsp;</td>
                <td>

                      <asp:DropDownList ID="cmbDept" runat="server" 
                                Width="95%" ToolTip="Select Department"  ClientIDMode="Static"  class="requiredField" >
                            </asp:DropDownList>
                          
                </td>
            </tr>


             <tr>
                <td style="text-align: right; vertical-align: top">Disc. Applicable :&nbsp;</td>
                <td>
                        <asp:RadioButtonList ID="rdoIsDiscountable" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                </td>
            </tr>

            <tr>
                <td style="text-align: right">Billing Category :&nbsp;</td>
                <td>
                    <asp:CheckBox ID="chkBillingCategory" ClientIDMode="Static" runat="server" Text="Self" />

                </td>
            </tr>

            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:DropDownList ID="ddlBillingCategory" ClientIDMode="Static" runat="server" Width="250px">
                    </asp:DropDownList>

                </td>
            </tr>
            <tr>
                <td>Revenue Name :&nbsp;</td>
                <td>
                    <asp:DropDownList ID="ddlRevenueMap" ClientIDMode="Static" runat="server" Width="250px" class="requiredField" >
                    </asp:DropDownList>

                </td>
            </tr>
        </table>
        <div class="filterOpDiv">

            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static"
                OnClick="btnSave_Click" OnClientClick="return validateRoom(this)"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
                            CssClass="ItDoseButton"></asp:Button>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mdpSave" runat="server" CancelControlID="btnCancel" DropShadow="true"
        TargetControlID="btnAddNew" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlSave"
        PopupDragHandleControlID="Div1" OnCancelScript="cancelRoom()">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlFloor" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div id="Div1" class="Purchaseheader" runat="server">
            Add New Floor
        </div>
        <table>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblFloor" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Floor Name :&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtFloorName" CssClass="required" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="100" Width="250px"></asp:TextBox>
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
            <asp:Button ID="btnSaveFloor" runat="server" Text="Save"
                CssClass="ItDoseButton" ClientIDMode="Static"
                OnClick="btnSaveFloor_Click" OnClientClick="return validateFloor(this);"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnCancelFloor" runat="server" Text="Cancel"
                            CssClass="ItDoseButton"></asp:Button>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpFloor" BehaviorID="mpFloor" runat="server" CancelControlID="btnCancelFloor" DropShadow="true"
        TargetControlID="btnAddnewFloor" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlFloor"
        PopupDragHandleControlID="Div1" OnCancelScript="cancelFloor()">
    </cc1:ModalPopupExtender>

    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>&nbsp;
</asp:Content>
