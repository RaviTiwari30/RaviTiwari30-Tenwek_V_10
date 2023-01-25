<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RateList.aspx.cs" Inherits="Design_EDP_RateList"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function checkAll(objRef) {
            var GridView = objRef.parentNode.parentNode.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;
                if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                    if (objRef.checked) {
                        inputList[i].checked = true;
                    }
                    else {
                        inputList[i].checked = false;
                    }
                }
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function checkItem() {
            if ($("#<%=lstItem.ClientID%> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Item to Show Rates');
                return false;
            }
        }
        function validate() {
            document.getElementById('<%=btnSave1.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave1.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave1', '');
        }
        var openCopytoCentreModel = function (e) {
            e.preventDefault();
            panelID = $("[id*=ddlPanelCompany]  option:selected").val()
            panelName = $("[id*=ddlPanelCompany]  option:selected").text();
            CentreName = $("[id*=ddlCentre]  option:selected").text()
            CentreID = $("[id*=ddlCentre]  option:selected").val()

            var divCopytoCentre = $('#divCopytoCentre');
            divCopytoCentre.find('#lblPanelCopyFrom').text(panelName).attr('panelID', panelID);
            divCopytoCentre.find('#lblCentreCopyFrom').text(CentreName).attr('CentreID', CentreID);

            $('#divCopytoCentre #chkCentre').find('input[type=checkbox]').each(function () {
                if (this.value == $('#lblCentreCopyFrom').attr('CentreID')) {
                    $(this).prop('checked', true);
                    $(this).prop('disabled',true);
                }
                else {
                    $(this).prop('checked', false);
                }
            });
            divCopytoCentre.showModel();
        }
        var CloseCopytoCentreModel = function () {
            $('#divCopytoCentre').closeModel();
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Rate List</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbDept" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobuttonlist" OnSelectedIndexChanged="rdbDept_SelectedIndexChanged"
                                AutoPostBack="True" ToolTip="Select IPD Or OPD Department">
                                <asp:ListItem Selected="True" Value="0">OPD</asp:ListItem>
                                <asp:ListItem Value="1">IPD</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkItemSearch" runat="server" Checked="True" Text="ItemName" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearchName" runat="server"
                                ToolTip="Enter Item Name" MaxLength="30"></asp:TextBox>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkCodeSearch" runat="server" Checked="True" Text="Item Code" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCodeSearch" runat="server" ToolTip="Enter Item Name" MaxLength="30" Width="290px" ></asp:TextBox>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkCat" runat="server" Checked="True" Text="Category" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                                ToolTip="Select Category">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rbtItemChar" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobuttonlist" AutoPostBack="True"
                                ToolTip="Select To Search Item By Initial Or Middle Character ">
                                <asp:ListItem Selected="True" Value="0">By Initial Characters</asp:ListItem>
                                <asp:ListItem Value="1">By Middle Characters</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5">
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkSubCat" runat="server" Checked="True" Text="Sub-Category" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" AutoPostBack="True"
                                ToolTip="Select Sub-Category">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnLoadItem" runat="server" CssClass="ItDoseButton" Text="Load Items >>" OnClick="btnLoadItem_Click" ToolTip="Click To Load Items" />
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Available Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstItem" runat="server" CssClass="opdsearchbox2" SelectionMode="Multiple" Height="106px" Width="290px"></asp:ListBox>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkPanel" runat="server" Checked="True" Text="Panel" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="ddlPanelCompany" runat="server"
                                AutoPostBack="True" OnSelectedIndexChanged="ddlPanelCompany_SelectedIndexChanged" Height="100"></asp:ListBox>
                        </div>
                        <div class="col-md-8">
                            <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">
                                Schedule Charges
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <asp:DropDownList ID="ddlScheduleCharge" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlScheduleCharge_SelectedIndexChanged"
                                ToolTip="Select Schedule Charges">
                            </asp:DropDownList>
                        </div>
                            </div>
                            <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">
                               Centre 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" AutoPostBack="true" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkRoomType" runat="server" Checked="True" Text="All&nbsp;&nbsp;&nbsp;<b>:</b>" TextAlign="Left" />
                            </label>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="cmbCaseType" runat="server" Height="100px"></asp:ListBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtActive" runat="server" CssClass="ItDoseRadiobuttonlist"
                                RepeatDirection="Horizontal" Width="257px" AutoPostBack="True" Visible="false"
                                OnSelectedIndexChanged="rbtActive_SelectedIndexChanged"
                                ToolTip="Select Active Or In-Active To Update Rates">
                                <asp:ListItem Selected="True" Value="1">Active Rates</asp:ListItem>
                                <asp:ListItem Value="0">In-Active Rates</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnRate" runat="server" CssClass="save" Text="Show Rates"
                                OnClick="btnRate_Click" ToolTip="Click To Show Rates" OnClientClick="return checkItem()" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                RateList Details
            </div>
            <div>
                <div style="overflow: auto; width: 100%;">
                    <asp:GridView ID="grdItemOPD" runat="server" Width="100%"  OnRowDataBound="grdItemOPD_RowDataBound" CssClass="GridViewStyle" ClientIDMode="Static"
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CatName" HeaderText="Category">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SubCatName" HeaderText="SubCategory">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Item Name">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblItemNameOPD" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Current Rate">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRate" onkeypress="return checkForSecondDecimal(this,event)" AutoCompleteType="Disabled" runat="server" MaxLength="10" Text='<%# Bind("Rate") %>' ClientIDMode="Static"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbRate" runat="server" TargetControlID="txtRate" ValidChars=".0987654321"></cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Currency">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                       <asp:DropDownList runat="server" ID="ddlRateCurrency"></asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Item Display Name">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemDisplay" MaxLength="150" runat="server" Text='<%# Eval("ItemDisplayName") %>' ClientIDMode="Static"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Code">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemCode" MaxLength="30" runat="server" Text='<%# Eval("ItemCode") %>' ClientIDMode="Static"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active Item" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False" HeaderText="ItemID">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD" ShowHeader="true" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkall" runat="server" Text="IPD" onclick="checkAll(this);" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkApplyIPD" runat="server" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                    <asp:GridView ID="grdItemIPD" runat="server" Width="100%" OnRowDataBound="grdItemIPD_RowDataBound" CssClass="GridViewStyle"
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CatName" HeaderText="Category">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SubCatName" HeaderText="SubCategory">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Item Name">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblItemNameIPD" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="RoomType" HeaderText="RoomType">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Current Rate">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRate" onkeypress="return checkForSecondDecimal(this,event)" AutoCompleteType="Disabled" runat="server" MaxLength="10" CssClass="ItDoseTextinputNum" Text='<%# Bind("Rate") %>'></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbRate1" runat="server" TargetControlID="txtRate" ValidChars=".0987654321"></cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Currency">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                       <asp:DropDownList runat="server" ID="ddlRateCurrency"></asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Item Display Name">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemDisplay" MaxLength="150" runat="server" Text='<%# Eval("ItemDisplayName") %>' ClientIDMode="Static"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Code">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemCode" MaxLength="30" runat="server" Text='<%# Eval("ItemCode") %>' ClientIDMode="Static"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active Item" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False" HeaderText="ItemID">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'></asp:Label>
                                    <asp:Label ID="lblCaseTypeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IPDCaseTypeID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:CheckBox ID="chkToAllRooms" runat="server" Text="Set Rate To Room Types" TextAlign="Left" />
               <%-- &nbsp;<asp:Button ID="btnSave" runat="server" CssClass="save margin-top-on-btn"
                    Text="Save" ToolTip="Click To Save" OnClick="btnSave_Click" OnClientClick="validate(); openServiceOfferedModel();" />--%>
                 &nbsp;<asp:Button ID="btnSave" runat="server" CssClass="save margin-top-on-btn"
                    Text="Save" ToolTip="Click To Save" OnClientClick="openCopytoCentreModel(event);" />
               
            </div>
        </asp:Panel>
    </div>

    <div id="divCopytoCentre" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divCopytoCentre" aria-hidden="true">&times;</button>
					<b class="modal-title">Copy Rates to other Centre</b>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-1"></div>
						<div class="col-md-22">
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										From Panel Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblPanelCopyFrom" class="pull-left patientInfo">
									</label>

								</div>
							</div>
                            <div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										From Centre Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblCentreCopyFrom" class="pull-left patientInfo">
									</label>

								</div>
							</div>
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Select  Centre To Copy
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
								<asp:CheckBoxList ID="chkCentre" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" CssClass="ItDoseCheckboxlist"></asp:CheckBoxList>
								</div>
							</div>
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="modal-footer">
                     <asp:Button ID="btnSave1" runat="server" CssClass="save margin-top-on-btn" Text="Save" OnClick="btnSave1_Click" />
					<button type="button" data-dismiss="divCopytoCentre" >Close</button>
				</div>
			</div>
		</div>
	</div>
     <script type="text/javascript">
         $("[id*=grdItemOPD] input, [id*=grdItemOPD] select").on("keydown", function (e) {
             var selector = $(this)[0].tagName;
             var id = $(this)[0].id;
             if (typeof ($(this).attr("type")) != "undefined") {
                 if (id == "txtRate")
                     selector += '[id="txtRate"]';
                 else if (id == "txtItemDisplay")
                     selector += '[id="txtItemDisplay"]';
                 else if (id == "txtItemCode")
                     selector += '[id="txtItemCode"]';
             }
             if (e.keyCode == 40) { //down
                 var next = $(this).closest("tr").next().find(selector);
                 if (next.length > 0) {
                     next.focus();
                 }
             }
             if (e.keyCode == 38) { //up
                 var prev = $(this).closest("tr").prev().find(selector);
                 if (prev.length > 0) {
                     prev.focus();
                 }
             }
         });

         $("[id*=grdItemIPD] input, [id*=grdItemIPD] select").on("keydown", function (e) {
             var selector = $(this)[0].tagName;
             var id = $(this)[0].id;
             if (typeof ($(this).attr("type")) != "undefined") {
                 if (id == "txtRate")
                     selector += '[id="txtRate"]';
                 else if (id == "txtItemDisplay")
                     selector += '[id="txtItemDisplay"]';
                 else if (id == "txtItemCode")
                     selector += '[id="txtItemCode"]';
             }
             if (e.keyCode == 40) { //down
                 var next = $(this).closest("tr").next().find(selector);
                 if (next.length > 0) {
                     next.focus();
                 }
             }
             if (e.keyCode == 38) { //up
                 var prev = $(this).closest("tr").prev().find(selector);
                 if (prev.length > 0) {
                     prev.focus();
                 }
             }
         });
    </script>
</asp:Content>
