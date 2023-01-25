<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewDoctorDetail.aspx.cs"
    MasterPageFile="~/DefaultHome.master" Inherits="Design_Doctor_ViewDoctorDetail" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        function ClickSelectbtn(e, btnName) {
            if (window.event.keyCode == 13) {
                var btn = document.getElementById(btnName);

                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                    return false;
                }
            }
        }

        function validateDoc(btn) {
            document.getElementById('<%=btnSave1.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave1.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave1', '');

        }

        function validateView() {
            document.getElementById('<%=btnView.ClientID%>').disabled = true;
            document.getElementById('<%=btnView.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnView', '');
        }
        var openCopytoCentreModel = function (e) {
            e.preventDefault();
            panelID = $("[id*=cmbPanel]  option:selected").val()
            panelName = $("[id*=cmbPanel]  option:selected").text();
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
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Doctor/Team Details</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
         
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                         <label class="pull-left">Doctor Type</label>   
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:RadioButtonList ID="rdodoctorType" runat="server"  RepeatDirection="Horizontal">
                <asp:ListItem Selected="True"  Value="0">Single</asp:ListItem>
                <asp:ListItem Value="1">Team</asp:ListItem>
            </asp:RadioButtonList>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                ToolTip="Enter Doctor Name" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" TabIndex="2"
                                ToolTip="Select Department">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Specialization
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSpecialization"
                                runat="server"
                                TabIndex="3" ToolTip="Select Specialization">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="4"
                Text="Search" OnClick="btnSearch_Click"
                ToolTip="Click To Search" />
            &nbsp;&nbsp;
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Doctor Details
                </div>
                <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="5" CssClass="GridViewStyle"
                    AllowPaging="true" PageSize="5">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Specialization" HeaderText="Specialization">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="170px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Degree" HeaderText="Degree">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="170px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Department" HeaderText="Department">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="170px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Doctor Share">
                            <ItemTemplate>
                                <asp:Label ID="lblDocShare" runat="server" Text='<%# (Util.GetInt(Eval("IsDocShare"))==1?"Yes":"No") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:HyperLinkField HeaderText="Edit" Text="Edit" DataNavigateUrlFields="DID,updateFlag,IsUnit"
                            DataNavigateUrlFormatString="~/Design/Doctor/DoctorEdit.aspx?DID={0}&amp;updateFlag={1}&amp;IsUnit={2}"
                            NavigateUrl="~/Design/Doctor/DoctorEdit.aspx">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="5px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:HyperLinkField>
                        <asp:CommandField HeaderText="Rate" SelectText="Rate" ShowSelectButton="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                        <asp:TemplateField HeaderText="Map">
                            <ItemTemplate>
                                <asp:Label ID="lblDID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblDoctorName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Name") %>'
                                    Visible="False"></asp:Label>


                                <div id="divbtnMapDotor" style='<%#(Eval("IsUnit").ToString()=="0" ? "display:none;": "cursor: pointer;")%>' onclick="openmapModel('<%# DataBinder.Eval(Container.DataItem,"Name") %>','<%# DataBinder.Eval(Container.DataItem,"DID") %>')">
                                    <input type="button" class="ItDoseButton" value="Map" />
                                </div>



                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <asp:Panel ID="Panel1" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Doctor Charges
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-8">
                            </div>
                            <div class="col-md-8">
                                <asp:RadioButton ID="rdbOPD" runat="server" GroupName="a" Text="OPD" AutoPostBack="True"
                                    OnCheckedChanged="rdbOPD_CheckedChanged" CssClass="ItDoseCheckboxlistSpl"
                                    ToolTip="Select OPD To Update" Checked="True" />&nbsp;
                            <asp:RadioButton ID="rdbIPD" runat="server" GroupName="a" Text="IPD" AutoPostBack="True"
                                OnCheckedChanged="rdbIPD_CheckedChanged"
                                CssClass="ItDoseCheckboxlistSpl" ToolTip="Select IPD To Update" />
                            </div>
                            <div class="col-md-8">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblSubCat" runat="server" Text="SubCategory : " Visible="False"></asp:Label>
                                </label>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbSubCategory" runat="server" CssClass="ItDoseDropdownbox"
                                    Visible="False" Width="256px" ToolTip="Select Sub Category">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblPanel" runat="server" Text="Panel"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbPanel" runat="server"
                                    ToolTip="Select Panel" AutoPostBack="true"
                                    OnSelectedIndexChanged="cmbPanel_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Schedule&nbsp;Charges
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlScheduleCharge" runat="server"
                                    AppendDataBoundItems="True"
                                    ToolTip="Select Schedule Charges">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblCaseType" runat="server" Text="CaseType" Visible="false"></asp:Label>
                                </label>
                                <b runat="server" id="lblcolan" visible="false" class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:ListBox ID="cmbCaseType" runat="server" CssClass="ItDoseTextinputText" SelectionMode="Multiple"
                                    Visible="false" Style="height: 100px;"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Centre</label><b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnView" runat="server" OnClick="btnView_Click" Text="View" CssClass="ItDoseButton"
                                    ToolTip="Click To View" OnClientClick="return validateView()" />
                            </div>
                            <div class="col-md-12">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <table border="0" style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 15%; text-align: right"></td>
                        <td colspan="3" style="text-align: left">
                            <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="30px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Name" HeaderText="Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Rate">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtRate" runat="server" Text='<%# Bind("Rate") %>' Width="92px"></asp:TextBox>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Is Scheduled">
                                        <ItemTemplate>
                                            <asp:CheckBox runat="server" ID="chkIsScheduled" Checked='<%# Util.GetBoolean(Eval("IsScheduled")) %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Kiosk" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkKiosk" runat="server" Text='<%# Eval("ShowFlag") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="General" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkGeneral" runat="server" Text='<%# Eval("ShowFlag") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRateID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container.DataItem,"RateListID") %>'></asp:Label>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
                                                Visible="False"></asp:Label>
                                            <asp:Label ID="lblSchedulecharge" runat="server" Text='<%# Eval("ScheduleChargeID") %>' />
                                            <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>' />
                                            <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="50px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td style="width: 35%">
                            <asp:CheckBox ID="ChkAllRoom" runat="server"
                                Text="Apply This Rate To All Rooms" ToolTip="Check To Apply Rates" Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right"></td>
                        <td colspan="2" style="width: 35%"></td>
                        <td style="width: 15%; text-align: right"></td>
                        <td style="width: 35%"></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="5">
                           <%-- <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave1_Click" CssClass="ItDoseButton"
                                Visible="False" ToolTip="Click To Save" OnClientClick="return validateDoc(this)" />--%>
                             &nbsp;<asp:Button ID="btnSave" runat="server" CssClass="save margin-top-on-btn"
                    Text="Save" ToolTip="Click To Save" Visible="False" OnClientClick="openCopytoCentreModel(event);" />
                        </td>
                    </tr>
                </table>

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

                                    <asp:Label ID="lblCentreCopyFrom" runat="server" class="pull-left patientInfo" ClientIDMode="Static"></asp:Label>
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
                    <asp:Button ID="btnSave1" runat="server" CssClass="save margin-top-on-btn" Text="Save" OnClientClick="return validateDoc(this);" OnClick="btnSave1_Click" />
                    <button type="button" data-dismiss="divCopytoCentre">Close</button>
                </div>
            </div>
        </div>
    </div>


    <%--//Map Team--%>
    <div class="modal fade" id="divMapTeam">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content" style="width: 1000px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closemapModel()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Map Doctor With Team.</h4>
                </div>
                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-3">
                            Team Name : 
                        </div>
                        <div class="col-md-21">
                            <label id="lblTeamId" style="display: none"></label>
                            <label id="lblTeamName"></label>
                        </div>


                    </div>
                    <div class="row">

                        <%--<div class="col-md-3">
                            <label class="pull-left">
                                Clinic
                            </label>
                            <b class="pull-right">:</b>
                        </div>--%>
                        <div class="col-md-5" style="display:none">
                            <asp:DropDownList ID="cmbDept" runat="server" TabIndex="8" ToolTip="Select Department" class="requiredField" onchange="BindAllDoctors();">
                            </asp:DropDownList>

                        </div> 
                        <div class="col-md-3">
                            <label class="pull-left">
                                Cadre Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCadre" onchange="$bindCadreDoctor()">
                            </select>
                        </div>

                        <div class="col-md-8">

                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Tier Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddltier" onchange="$bindTierDoctor()">
                            </select>
                        </div>



                    </div>

                    <div class="row">
                       <%-- <div class="col-md-3" id="divDoctors">
                            <label class="pull-left">
                                Doctors
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="divDoctor">
                            <select id="ddlDoctor" class="" title="Select Doctor" style="">
                            </select>
                        </div>--%>

                        <div class="col-md-3" id="divCadre">
                            <label class="pull-left">
                                Cadre Doctors
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="divCadreDoc">
                            <select id="ddlCadreDoctor" class="" title="Select Cadre Doctor" style="">
                            </select>
                        </div>
                         <div class="col-md-8">

                        </div>
                        <div class="col-md-3" id="divTier">
                            <label class="pull-left">
                                Tier Doctors
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="divTierDoc">
                            <select id="ddlTierDoctor" class="" title="Select Tier Doctor" style="">
                            </select>
                        </div>
                        <div class="row"></div>
                        <div class="row">
                            <%--<div class="col-md-9" style="text-align: center">
                                <input type="button" id="btnDoctor" value="Add Doctor" style="text-align: center" onclick="addDoctorToTable()" />
                            </div>--%>
                            <div class="col-md-9" style="text-align: center">
                                <input type="button" id="btnCadreDoc" value="Add Cadre" style="text-align: center" onclick="addCadreToTable()" />
                            </div>
                             <div class="col-md-8">

                        </div>
                            <div class="col-md-6" style="text-align: center">
                                <input type="button" id="btnTierDoc" value="Add Tier" style="text-align: center" onclick="addTierToTable()" />
                            </div>
                        </div>

                        <div class="row"></div>

                        <div class="row" id="divDoctorname">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor's Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                                <div id="divDoctorList" class="chosen-container-multi">
                                    <table id="tblDoctorList" class="GridViewStyle" cellspacing="0" rules="all" border="1">
                                        <thead class="GridViewHeaderStyle"></thead>
                                        <tbody></tbody>
                                    </table>


                                </div>
                            </div>
                        </div>

                    </div>


                </div>
                <div class="modal-footer">
                    <input type="button" id="btnMap" value="Save" onclick="MapTeam()" />
                </div>
            </div>

        </div>
    </div>

    <%--// Close Map Team
    --%>
    <script type="text/javascript">
        $(document).ready(function () {
            $bindCadreType(function () { });
            $bindTierType(function () { });
        });
        var $bindCadreType = function (callback) {
            serverCall('../EDP/UserPrivilege/UserPrivilege.asmx/bindCadreType', {}, function (response) {
                var $ddlCadre = $('#ddlCadre');
                $ddlCadre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CadreName' });
                callback($ddlCadre.val());
            });
        }
        var $bindTierType = function (callback) {
            serverCall('../EDP/UserPrivilege/UserPrivilege.asmx/bindTierType', {}, function (response) {
                var $ddltier = $('#ddltier');
                $ddltier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'TierName' });
                callback($ddltier.val());
            });
        }

        function BindAllDoctors() {
            var txt = $("#<%=cmbDept.ClientID%> option:selected").text();
            BindDoctor(txt, function () { });
        }


        function BindDoctor(department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/BindDoctorWithoutUnit', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'NAME', isSearchAble: true, selectedValue: 'Select' });

                callback($ddlDoctor.val());
            });
        }

        function $bindCadreDoctor() {
            var id = $("#ddlCadre").val();
            serverCall('ViewDoctorDetail.aspx/bindCadreDoctor', { Id: id }, function (response) {
                var $ddlCadreDoctor = $('#ddlCadreDoctor');
                $ddlCadreDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });

            });
        }

        function $bindTierDoctor() {
            var id = $("#ddltier").val();
            serverCall('ViewDoctorDetail.aspx/bindTierDoctor', { Id: id }, function (response) {
                var $ddlTierDoctor = $('#ddlTierDoctor');
                $ddlTierDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });

            });
        }


        var openmapModel = function (TeamName, TeamId) {
            $("#lblTeamId").text(TeamId);
            $("#lblTeamName").text(TeamName);

            getMappedDr(TeamId)
            $("#divMapTeam").showModel();
        }

        var $closemapModel = function () {

            $('#tblDoctorList tbody').empty();
            $("#divMapTeam").hideModel();

        }


        function addUnitDoctor(doc) {
            if (isDocAdded(doc.docID, $('#tblDoctorList'))) {
                modelAlert('Doctor Already Selected')
                return false;
            }

            // Add table header
            var tHead = $('#tblDoctorList thead')
            if (tHead.find('tr').length == 0) {
                var tHeadContent = '<tr>'
                tHeadContent += '<td style="width:20px">S.No.</td>'
                tHeadContent += '<td style="width:300px;display:none">ID</td>'
                tHeadContent += '<td style="width:300px">Name</td>'
                tHeadContent += '<td style="width:100">Position</td>'

                tHeadContent += '<td style="width:100;display:none">TierId</td>'
                tHeadContent += '<td style="width:100;display:none">TierName</td>'
                tHeadContent += '<td style="width:100;display:none">CadreId</td>'
                tHeadContent += '<td style="width:100;display:none">CadreName</td>'
                tHeadContent += '<td style="width:100;display:none">TeamId</td>'
                tHeadContent += '<td style="width:100;display:none">TeamName</td>'
                tHeadContent += '<td style="width:100;display:none">Type</td>'

                tHeadContent += '<td>Action</td>'
                tHeadContent += '</tr>'
                tHead.append(tHeadContent);
            }
            // Add table data 

            var tBody = $('#tblDoctorList tbody')
            var i = tBody.find('tr').length;
            var tBodyContent = '<tr id=' + doc.docID + ' tableid=' + ++i + '>'

            tBodyContent += '<td>' + i + '</td>'
            tBodyContent += '<td id="docId" style="width:100;display:none">' + doc.docID + '</td>'
            tBodyContent += '<td id="docName">' + doc.docName + '</td>'
            tBodyContent += '<td id="docPos"><span id="spnDocPos">' + doc.docPosition + '</span></td>'

            tBodyContent += '<td id="tdTierId" style="width:100;display:none">' + doc.TierId + '</td>'
            tBodyContent += '<td id="tdTierName" style="width:100;display:none">' + doc.TierName + '</td>'
            tBodyContent += '<td  style="width:100;display:none"><span id="tdCadreId" style="width:100;display:none">' + doc.CadreId + '</span></td>'
            tBodyContent += '<td id="tdCadreNames" style="width:100;display:none">' + doc.CadreName + '</td>'
            tBodyContent += '<td id="tdTeamId" style="width:100;display:none">' + doc.TeamId + '</td>'
            tBodyContent += '<td id="tdTeamName" style="width:100;display:none">' + doc.TeamName + '</td>'
            tBodyContent += '<td  style="width:100;display:none"><span id="tdType" style="width:100;display:none">' + doc.Type + '</span></td>'

            
            tBodyContent += '<td><input type="button" value="Remove"  onclick="onRemoveDoctor(this)" class="ItDoseButton" /></td>'
            tBodyContent += '</tr>'
            tBody.append(tBodyContent);
            
        }


        var isDocAdded = function (docId, ob) {
            var isExist = $(ob).find('#' + docId)
            if (isExist.length > 0)
                return true
        }

        function addDoctorToTable() {


            var docId = $('#ddlDoctor').val();

            if (docId == 0 || docId == null || docId == '') {
                return false;
            }
            if (!isDocAdded(docId, $('#tblDoctorList'))) {
                var doctorList = {
                    docID: docId,
                    docName: $('#ddlDoctor option:selected').text(),
                    docPosition: "Senior",
                    TierId: "",
                    TierName: "",
                    CadreId: "",
                    CadreName: "",
                    TeamId: $("#lblTeamId").text(),
                    TeamName: $("#lblTeamName").text(),
                    Type: "0",

                }
                addUnitDoctor(doctorList, function () { })
            }


        }

        function addCadreToTable() {


            var docId = $('#ddlCadreDoctor').val();
            if (docId == 0 || docId == null || docId == '') {
                return false;
            }

            if (!isDocAdded(docId, $('#tblDoctorList'))) {
                var doctorList = {
                    docID: docId,
                    docName: $('#ddlCadreDoctor option:selected').text(),
                    docPosition: $('#ddlCadre option:selected').text(),
                    TierId: "",
                    TierName: "",
                    CadreId: $('#ddlCadre').val(),
                    CadreName: $('#ddlCadre option:selected').text(),
                    TeamId: $("#lblTeamId").text(),
                    TeamName: $("#lblTeamName").text(),
                    Type: "1",

                }
                addUnitDoctor(doctorList, function () { })
            }


        }

        function addTierToTable() {
            var docId = $('#ddlTierDoctor').val();
            if (docId == 0 || docId == null || docId == '') {
                return false;
            }

            if (!isDocAdded(docId, $('#tblDoctorList'))) {
                var doctorList = {
                    docID: docId,
                    docName: $('#ddlTierDoctor option:selected').text(),
                    docPosition: $('#ddltier option:selected').text(),
                    TierId: $('#ddltier').val(),
                    TierName: $('#ddltier option:selected').text(),
                    CadreId: "",
                    CadreName: "",
                    TeamId: $("#lblTeamId").text(),
                    TeamName: $("#lblTeamName").text(),
                    Type: "1",

                }
                addUnitDoctor(doctorList, function () { })
            }


        }


        var onRemoveDoctor = function (el) {
            $(el).closest('tr').remove();
            saveUnitDoctor();
            // update table sno.
            var c = 1; var gname = 'sharetype_' + c
            $('#tblDoctorList tbody').find('tr').each(function () {
                $(this).find('input[type=radio]').attr('name', 'sharetype_' + c)
                $(this).find('td:first-child').html(c++)
            })

            if ($('#tblDoctorList tbody').find('tr').length == 0) {
                $('#tblDoctorList tHead').find('tr').remove()
                // $('#lblPosition').css("display", "none");
                // $('#ddlPosition').css("display", "none");

                $('#lblPosition').css("display", "");
                $('#ddlPosition').css("display", "");
            }
        }

        function MapTeam() {

            var data = new Array();
            var Obj = new Object();
            jQuery("#tblDoctorList tbody tr").each(function (i) {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                Obj.docID = jQuery.trim($rowid.find("#docId").text());
                Obj.docName = jQuery.trim($rowid.find("#docName").text());
                Obj.docPosition = jQuery.trim($rowid.find("#spnDocPos").text());
                Obj.TierId = jQuery.trim($rowid.find("#tdTierId").text());
                Obj.TierName = jQuery.trim($rowid.find('#tdTierName').text());
                Obj.CadreId = jQuery.trim($rowid.find('#tdCadreId').text());
                Obj.CadreNames = jQuery.trim($rowid.find('#tdCadreNames').text());
                Obj.TeamId = jQuery.trim($rowid.find("#tdTeamId").text());
                Obj.TeamName = jQuery.trim($rowid.find("#tdTeamName").text());
                Obj.Type = jQuery.trim($rowid.find("#tdType").text());  
                data.push(Obj);
                Obj = new Object();
                
                 
            });

            console.log(data)



            if (data.length > 0) {
                $.ajax({
                    url: "ViewDoctorDetail.aspx/MapTeam",
                    data: JSON.stringify({ Data: data}),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: true,
                    dataType: "json",
                    success: function (result) {
                        Data = result.d;
                        if (Data == "1") {
                            modelAlert('Record Saved Successfully', function () {
                                $closeIndentModel();
                                window.location.reload();
                            });
                        }
                        else {
                            $('#btnSave').text('Save').removeAttr('disabled');
                        }
                    },
                    error: function (xhr, status) {
                        modelAlert(status + "\r\n" + xhr.responseText);
                        $('#btnSave').text('Save').removeAttr('disabled');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }



        }



        function getMappedDr(Id) {
              
            serverCall('ViewDoctorDetail.aspx/getMappedDoctor', { TeamId: Id }, function (response) {
                 
                var ItemData = JSON.parse(response);

                if (ItemData.status) {
                     
                        data = ItemData.data;
                        $('#divAppendMessage').empty();
                        $.each(data, function (i, item) {
                            
                            var doctorList = {
                                docID: item.DoctorListId,
                                docName: item.EmpName,
                                docPosition: item.Position,
                                TierId: item.TeirId,
                                TierName: item.TeirName,
                                CadreId: item.CadreId,
                                CadreName: item.CadreName,
                                TeamId: item.UnitDoctorID,
                                TeamName: item.UnitName,
                                Type: item.Type,

                            }
                            addUnitDoctor(doctorList, function () { });

                        });
                       
                }  

            });

        }







    </script>

</asp:Content>
