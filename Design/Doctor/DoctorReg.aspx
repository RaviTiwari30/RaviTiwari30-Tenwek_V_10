<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" CodeFile="DoctorReg.aspx.cs" Inherits="Design_Doctor_DoctorReg" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#lbldoctor").css("display", "none");
            $("#divDoctor").css("display", "none");
            $('#divDoctorname').css("display", "none");
            $('#divDoctors').css("display", "none");
            $('#lblPosition').hide();
            $('#ddlPosition').hide();
        });

        function ShowHideDiv(elem) {
            var value = elem.value;
            if (value == "Single") {
                $("#lbldoctor").css("display", "none");
                $("#divDoctor").css("display", "none");
                $('#divDoctorname').css("display", "none");
                $('#divDoctors').css("display", "none");
                $("#lblType").text(0);
                $("#hfType").val(0);
                $('#<%=ddldoctorgroup.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "0") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlSpecial.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "0") { $(this).attr("selected", "selected") }
                });

                $('#<%=cmbDept.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "0") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlCadre.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "0") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlTier.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "0") { $(this).attr("selected", "selected") }
                });

                $('#lblPosition').hide();
                $('#ddlPosition').hide();
                
                // $('#<%=ddldoctorgroup.ClientID%>').attr("disabled", false);
                $('#cmbTitle option:selected').text('Dr.');
            }
            else {
                $("#lbldoctor").css("display", "");
                $("#divDoctor").css("display", "");
                $('#divDoctorname').css("display", "");
                $('#divDoctors').css("display", "");
                $("#lblType").text(1);
                $("#hfType").val(1);
                $('#cmbTitle option:selected').text('');

                $('#<%=ddldoctorgroup.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "7") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlSpecial.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "69") { $(this).attr("selected", "selected") }
                });

                $('#<%=cmbDept.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "57") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlCadre.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "9") { $(this).attr("selected", "selected") }
                });
                $('#<%=ddlTier.ClientID%>').find('option').each(function () {
                    if ($(this).val() == "9") { $(this).attr("selected", "selected") }
                });

                $('#lblPosition').show();
                $('#ddlPosition').show();

               // $('#<%=ddldoctorgroup.ClientID%>').attr("disabled", true);
            }
        }

      

        function BindAllDoctors() {
            var txt = $("#<%=cmbDept.ClientID%> option:selected").text();
           // BindDoctor(txt, function () { });
        }

        function ShowText() {
            var chk = document.getElementById('<%=chkLogin.ClientID %>');
            if (chk.checked == true)
                document.getElementById('<%=pnlLogin.ClientID %>').style.display = '';
            else
                document.getElementById('<%=pnlLogin.ClientID %>').style.display = 'none';
        }
        function validatespace() {
            var Docname = $('#<%=txtName.ClientID %>').val();
            if (Docname.charAt(0) == ' ' || Docname.charAt(0) == '.' || Docname.charAt(0) == ',') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Docname.replace(Docname.charAt(0), "");
                return false;
            }
            else {
                return true;
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
            var Docname = $('#<%=txtName.ClientID %>').val();
            if (Docname.charAt(0) == ' ') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }

        function validateDoc() {
            if ($('#<%=txtName.ClientID %>').val() == "") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Enter Name');
                $('#<%=txtName.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddldoctorgroup.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Group');
                $('#<%=ddldoctorgroup.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddlSpecial.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Sepcilization');
                $('#<%=ddlSpecial.ClientID %>').focus();
                return false;
            }
            if ($('#<%=cmbDept.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Sepcilization');
                $('#<%=cmbDept.ClientID %>').focus();
                return false;
            }
            if ($('#<%=grdTime.ClientID %> tr').length == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Specify Day Or Date of Timings');
                $('#<%=btntimings.ClientID %>').focus();
                return false;
            }
            var iFlag = 0;
            if (($('#<%=chkMon.ClientID %>').is(':checked')) || ($('#<%=chkTues.ClientID %>').is(':checked')) || ($('#<%=chkWed.ClientID %>').is(':checked')) || ($('#<%=chkThur.ClientID %>').is(':checked')) || ($('#<%=chkFri.ClientID %>').is(':checked')) || ($('#<%=chkSat.ClientID %>').is(':checked')) || ($('#<%=chkSun.ClientID %>').is(':checked')))
                iFlag = 1;
            if (($('#<%=grdTime.ClientID %> tr').length == "0") && (iFlag == "0")) {
                $('#<%=lblerrmsg.ClientID %>').text('Please Specify Day Or Date of Timings');
                $('#<%=chkMon.ClientID %>').focus();
                return false;
            }
            if ($('#<%=chkLogin.ClientID %>').is(':checked')) {
                if ($('#<%=txtUsername.ClientID %>').val() == "") {
                    $('#<%=lblerrmsg.ClientID %>').text('Please Enter User Name');
                    $('#<%=txtUsername.ClientID %>').focus();
                    return false;
                }
                if ($('#<%=txtPassword.ClientID %>').val() == "") {
                    $('#<%=lblerrmsg.ClientID %>').text('Please Enter User Name');
                    $('#<%=txtPassword.ClientID %>').focus();
                    return false;
                }
                if ($('#<%=txtPassword.ClientID %>').val() != $('#<%=txtConfirmpwd.ClientID %>').val()) {
                    $('#<%=txtConfirmpwd.ClientID %>').focus();
                    $('#<%=lblerrmsg.ClientID %>').text('Password Does Not Match');
                    return false;
                }
                if ($('#ctl00_ContentPlaceHolder1_Lbl_Helplabel').text() != "") {
                    $("#<%=lblerrmsg.ClientID%>").text('Please Enter The ' + $('#ctl00_ContentPlaceHolder1_Lbl_Helplabel').text());
                      $("#<%=txtPassword.ClientID%>").focus();
                      return false;
                  }
            }

            if ($('#<%=ddlCadre.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Cadre');
                 $('#<%=ddlCadre.ClientID %>').focus();
                 return false;
            }
            if ($('#<%=ddlTier.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Tier');
                $('#<%=ddlTier.ClientID %>').focus();
                return false;
            }

            var docShare = "";
            if ($('#<%=rblDocShare.ClientID%>' + '_0').is(':checked')) {
                docShare = "0";//yes
            }
            else {
                docShare = "1";//No
            }

            var typevale = $("input[name='rbType']:checked").val();
            if (typevale == "Unit" && docShare == "1") {
                var d = "";
                $('#ulDocyorList li').each(function (i) {
                    if (i == 1) {
                        d += $(this).attr('id') + ",";
                    }
                    else {
                        d += $(this).attr('id') + ",";
                    }
                });
                $('#<%=txtUnitDoctorList.ClientID%>').val(d);
            }
            else if (typevale == "Unit" && docShare == "0")
            {
                
            }

            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function SaveDocShareUnit(DocID) {
            $getDoctorShareDetails(function ($ShareData) {
                serverCall('Services/DocGrouprateMaster.asmx/SaveDoctorUnit', { ShareDetails: $ShareData, DoctorID: DocID }, function () {
                    modelAlert("Doctor saved Successfully.");
                    location.reload();
                });
            });
        }

        function Save() {
            modelAlert("Doctor saved Successfully.");
            location.reload();
        }

        function BindDoctor(department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/BindDoctorWithoutUnit', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'NAME', isSearchAble: true, selectedValue: 'Select' });

                callback($ddlDoctor.val());
            });
        }
    </script>
    <div id="Pbody_box_inventory" style="text-align: left;">
        <ajax:ScriptManager ID="ScriptManager1" runat="server">
        </ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Clinician Registration</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Details &nbsp;
            </div>
            
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <%--<asp:RadioButtonList ID="rbtType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">Single</asp:ListItem>
                                <asp:ListItem Value="1">Unit</asp:ListItem>
                            </asp:RadioButtonList>--%>
                             <input type="radio" name="rbType" value="Single" onclick="ShowHideDiv(this);" checked="checked" id="rbSingle"/>Single
                             <input type="radio" name="rbType" value="Unit" onclick="ShowHideDiv(this);" id="rbUnit"/>Team
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>Dr.

                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbTitle" runat="server" TabIndex="1"
                                Width="66px" ClientIDMode="Static">
                                <asp:ListItem Selected="True">Dr.</asp:ListItem>
								<asp:ListItem>RCO</asp:ListItem>
                                <asp:ListItem>Rev.</asp:ListItem>
                                <asp:ListItem>Past.</asp:ListItem>
                                <asp:ListItem>Mr.</asp:ListItem>
                                <asp:ListItem>Ms.</asp:ListItem>
                                <asp:ListItem>Miss</asp:ListItem>
                                <asp:ListItem>Mrs.</asp:ListItem>
                                <asp:ListItem Value="5"></asp:ListItem>
                              
                            </asp:DropDownList>
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                MaxLength="100" onkeyup="validatespace();" TabIndex="2" Width="138px" ToolTip="Enter Doctor Name" class="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor&nbsp;Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldoctorgroup" runat="server" Width="95%" class="requiredField"
                                TabIndex="3" ToolTip="Select Doctor Type" ClientIDMode="Static">
                            </asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhone1" runat="server" AutoCompleteType="Disabled" MaxLength="20"
                                TabIndex="4" Width="222px" ToolTip="Enter Phone No."></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtPhone" runat="server" FilterType="Numbers ,Custom"
                                TargetControlID="txtPhone1" ValidChars="+">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Mobile
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="TxtMobileNo" runat="server" AutoCompleteType="Disabled"
                                TabIndex="5" Width="208px" ToolTip="Enter Mobile No." class="requiredField"></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAdd" runat="server" Height="53px" MaxLength="50"
                                TabIndex="6" TextMode="MultiLine" Width="223px" ToolTip="Enter Address"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Specialization
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSpecial" runat="server" TabIndex="7"
                                Width="95%" OnSelectedIndexChanged="ddlSpecial_SelectedIndexChanged" ToolTip="Select Specialization" class="requiredField" ClientIDMode="Static">
                            </asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Clinic
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbDept" runat="server" TabIndex="8"
                                Width="95%" ToolTip="Select Department" class="requiredField" onchange="BindAllDoctors();" ClientIDMode="Static" >
                            </asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Degree
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDocDegree" runat="server" ToolTip="Enter Degree" TabIndex="9" MaxLength="50"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Disc. Applicable
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoIsDiscountable" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                      
                    </div>

                    <div class="row">
                       <div class="col-md-3">
                            <label class="pull-left">Cadre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCadre" runat="server" class="requiredField"  ToolTip="Select Cadre" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Tier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTier" runat="server"  class="requiredField"  ToolTip="Select Tier" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Emer. Available
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblIsAvailableEmergency" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>

                        <div class="col-md-3"   style="display:none">
                            <label class="pull-left">
                                Doctors
                            </label>
                            <b class="pull-right" style="display:none">:</b>
                        </div>
                        <div class="col-md-5"  style="display:none">
                            <select id="ddlDoctor" class="" title="Select Doctor" style="">
                            </select>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3" id="lblPosition" style="display:none">
                            <label class="pull-left">
                               Position
                            </label>
                            <b class="pull-right" style="display:none">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <select id="ddlPosition"  >                              
                                <option value="1">Senior</option>
                                <option value="2">Junior</option>
                            </select>
                        </div>
                    </div>
                    <div class="row" id="divDoctorname" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left" style="display:none">
                                Doctor's Name
                            </label>
                            <b class="pull-right" style="display:none">:</b>
                        </div>
                        <div class="col-md-21" style="display:none">
                            <div id="divDoctorList" class="chosen-container-multi">
                                <table id="tblDoctorList" class="GridViewStyle" cellspacing="0" rules="all" border="1" >
                                    <thead class="GridViewHeaderStyle"></thead>
                                    <tbody></tbody>
                                </table>
                                <ul id="ulDocyorList" runat="server" clientidmode="Static" style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                                </ul>
                                
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5" style="display:none">
                            <asp:TextBox ID="txtUnitDoctorList" runat="server" style="display:none;"></asp:TextBox>
                            <asp:Label ID="lblType" runat="server" ClientIDMode="Static" style="display:none;"></asp:Label>
                            <asp:HiddenField ID="hfType" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
                    <div class="row" style="display:none">
                          <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Doctor Share
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:RadioButtonList ID="rblDocShare" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Slot Wise Token
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblIsSlotWiseToken" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal" onchange="BindTime();">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Doc.TimeDisplay</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDoctorTiminig" runat="server" TextMode="MultiLine" Height="40px"></asp:TextBox>

                        </div>
                    </div>
                    <div class="row">
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                OPD Schedule Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                <asp:RadioButtonList ID="rbtnType" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbtnType_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="1">By Days</asp:ListItem>
                                    <asp:ListItem Value="2">By Date</asp:ListItem>
                                </asp:RadioButtonList>
                            </label>
                        </div>
                        <div id="trDaysWise" runat="server" class="col-md-14">
                            <label class="pull-left">
                                Days&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b>&nbsp;&nbsp;&nbsp;&nbsp;
                            </label>
                            <asp:CheckBox ID="chkMon" runat="server" Height="11px" TabIndex="10" Text="Mon" Width="72px"
                                ToolTip="Check Monday" />
                            <asp:CheckBox ID="chkTues" runat="server" Height="11px" TabIndex="11" Text="Tues"
                                Width="75px" ToolTip="Check Tuesday" />
                            <asp:CheckBox ID="chkWed" runat="server" Height="11px" TabIndex="12" Text="Wed" Width="74px"
                                ToolTip="Check Wednesday" />
                            <asp:CheckBox ID="chkThur" runat="server" Height="11px" TabIndex="13" Text="Thur"
                                Width="72px" ToolTip="Check Thrusday" />
                            <asp:CheckBox ID="chkFri" runat="server" Height="11px" TabIndex="14" Text="Fri" Width="62px"
                                ToolTip="Check Friday" />
                            <asp:CheckBox ID="chkSat" runat="server" Height="11px" TabIndex="15" Text="Sat" Width="67px"
                                ToolTip="Check Saturday" />
                            <asp:CheckBox ID="chkSun" runat="server" Height="11px" TabIndex="16" Text="Sun" Width="70px"
                                ToolTip="Check Sunday" />
                        </div>
                        <div id="trDateWise" runat="server" visible="false" class="col-md-8">
                            <label class="pull-left">
                                Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b>&nbsp;&nbsp;&nbsp;&nbsp;
                            </label>
                            <asp:TextBox ID="txtDate" ClientIDMode="Static" runat="server" ToolTip="Select Date" Width="129px"
                                TabIndex="1"></asp:TextBox>
                            <asp:CheckBox ID="chkRepeat" runat="server" Text="Repeat Date Every Month" Visible="false" />
                            <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCentre" runat="server" ></asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Start Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr1" runat="server" MaxLength="2" TabIndex="17"
                                Width="33px" ToolTip="Enter Start Time"></asp:TextBox>
                            <asp:TextBox ID="txtMin1" runat="server" MaxLength="2" TabIndex="18"
                                Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                            <asp:DropDownList ID="cmbAMPM1" runat="server" TabIndex="19"
                                Width="57px" ToolTip="Select AM Or PM">
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe1" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr1">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe2" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin1">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RangeValidator ID="rangetxtHr1" runat="server" ControlToValidate="txtHr1" MinimumValue="0"
                                MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                            <asp:RangeValidator ID="rangetxtMin1" runat="server" ControlToValidate="txtMin1"
                                MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                End Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr2" runat="server" MaxLength="2" TabIndex="20"
                                Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                            <asp:TextBox ID="txtMin2" runat="server" MaxLength="2" TabIndex="21"
                                Width="33px" ToolTip="Enter Minutes"></asp:TextBox><asp:DropDownList ID="cmbAMPM2"
                                    runat="server" TabIndex="22" Width="57px" ToolTip="Select AM Or PM">
                                    <asp:ListItem>AM</asp:ListItem>
                                    <asp:ListItem>PM</asp:ListItem>
                                </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe3" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr2">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe4" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin2">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RangeValidator ID="rangetxtHr2" runat="server" ControlToValidate="txtHr2" MinimumValue="0"
                                MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                            <asp:RangeValidator ID="rangetxtMin2" runat="server" ControlToValidate="txtMin2"
                                MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Shift
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlDocTimingShift" runat="server" ToolTip="Select Shift" class="requiredField"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-8">
                            <asp:UpdatePanel ID="up4" runat="server">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btntimings" EventName="Click" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:Button ID="btntimings" runat="server" CssClass="ItDoseButton" OnClick="btntimings_Click"
                                TabIndex="25" Text="Add Timings" ToolTip="Click To Add Timings" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            

                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Duration for Patient
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlduration" runat="server" Width="50px" TabIndex="26" ToolTip="Select Duration For Patients">
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;(IN Minutes)
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddldurationOld" Width="50px" runat="server" TabIndex="27" ToolTip="Select Duration For Old Patients" Style="display: none;">
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:UpdatePanel ID="up7" runat="server">
                                <ContentTemplate>
                            <asp:GridView ID="grdTime" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowDeleting="grdTime_RowDeleting" Width="100%" Height="52px" Style="margin-left: 0px">
                                <Columns>
                                     <asp:BoundField DataField="CentreName" HeaderText="Centre" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="Day" HeaderText="Days" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                                    <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                                    <asp:BoundField DataField="AvgTime" HeaderText="Duration For Patient" />
                                    <asp:BoundField DataField="StartBufferTime" HeaderText="Start BT" Visible="false" />
                                    <asp:BoundField DataField="EndBufferTime" HeaderText="End BT" Visible="false" />
                                    <asp:BoundField DataField="ShiftName" HeaderText="Shift" />
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRepeat" runat="server" Text='<%#Eval("IsRepeat") %>'></asp:Label>
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            <asp:Label ID="lblStartTime" runat="server" Text='<%#Eval("StartTime") %>'></asp:Label>
                                            <asp:Label ID="lblEndTime" runat="server" Text='<%#Eval("EndTime") %>'></asp:Label>
                                            <asp:Label ID="lblShiftName" runat="server" Text='<%#Eval("ShiftName") %>'></asp:Label>
                                            <asp:Label ID="lblCentreID" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                             <asp:Label ID="lblDurationforOldPatient" runat="server" Text='<%#Eval("DurationforOldPatient") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowDeleteButton="True" ButtonType="Image" DeleteImageUrl="~/Images/Delete.gif" />
                                </Columns>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <AlternatingRowStyle CssClass="GridViewItemStyle" />
                            </asp:GridView>
                                </ContentTemplate>
                                </asp:UpdatePanel>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%" runat="server">
                    <tr runat="server" visible="false">
                        <td style="width: 14%; text-align: right">Start Buffer Time :&nbsp;
                        </td>
                        <td style="width: 45%; text-align: left">
                            <asp:TextBox ID="txtStartBT" runat="server" Width="44px" TabIndex="23" ToolTip="Enter Start Buffer Time"></asp:TextBox>
                            ( in minutes )<cc1:FilteredTextBoxExtender ID="ftb5" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtStartBT">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 20%; text-align: right">End Buffer Time :
                        </td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtEndBT" runat="server" Width="44px" TabIndex="24" ToolTip="Enter End Buffer Time"></asp:TextBox>
                            &nbsp;(In Minutes)<cc1:FilteredTextBoxExtender ID="ftb6" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtEndBT">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Not-Available Schedule Details
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        Centre
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlNACentre" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtNotAvailableDateFrom" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdNAFrom" runat="server" TargetControlID="txtNotAvailableDateFrom"
                        Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtNotAvailableDateTo" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdNATo" runat="server" TargetControlID="txtNotAvailableDateTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnNASearch" runat="server" CssClass="ItDoseButton" OnClick="btnNASearch_Click" Text="Search" ToolTip="Click To Search" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22" style="max-height: 150px; overflow: auto;">
                    <asp:GridView ID="grdNATiming" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Style="margin-left: 0px" Width="100%">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderStyle Width="10px" HorizontalAlign="Center" />
                                <ItemStyle Width="10px" HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    Select
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server" Width="10px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                              <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    Date
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblCentre" runat="server" Text='<%#Eval("CentreName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    Date
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDateValue" runat="server" Text='<%#Eval("DateValue") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    Day
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDayValue" runat="server" Text='<%#Eval("DayValue") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <HeaderTemplate>From Time</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtNAHr1" runat="server" Text="00" MaxLength="2" Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                                    <asp:TextBox ID="txtNAMin1" runat="server" Text="10" MaxLength="2" Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                                    <asp:DropDownList ID="cmbNAAMPM1" runat="server" Width="57px" ToolTip="Select AM Or PM">
                                        <asp:ListItem>AM</asp:ListItem>
                                        <asp:ListItem>PM</asp:ListItem>
                                    </asp:DropDownList>
                                    <cc1:FilteredTextBoxExtender ID="ftbtxtNAHr1" runat="server" FilterType="Custom,Numbers"
                                        TargetControlID="txtNAHr1">
                                    </cc1:FilteredTextBoxExtender>
                                    <cc1:FilteredTextBoxExtender ID="ftbtxtNAMin1" runat="server" FilterType="Custom,Numbers"
                                        TargetControlID="txtNAMin1">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:RangeValidator ID="rangetxtNAHr1" runat="server" ControlToValidate="txtNAHr1" MinimumValue="0"
                                        MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                                    <asp:RangeValidator ID="rangetxttxtNAMin1" runat="server" ControlToValidate="txtNAMin1"
                                        MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <HeaderTemplate>To Time</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="txtNAHr2" runat="server" Text="11" MaxLength="2" Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                                    <asp:TextBox ID="txtNAMin2" runat="server" Text="50" MaxLength="2" Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                                    <asp:DropDownList ID="cmbNAAMPM2" runat="server" Width="57px" ToolTip="Select AM Or PM">
                                        <asp:ListItem>AM</asp:ListItem>
                                        <asp:ListItem>PM</asp:ListItem>
                                    </asp:DropDownList>
                                    <cc1:FilteredTextBoxExtender ID="ftbtxtNAHr2" runat="server" FilterType="Custom,Numbers"
                                        TargetControlID="txtNAHr2">
                                    </cc1:FilteredTextBoxExtender>
                                    <cc1:FilteredTextBoxExtender ID="ftbtxtNAMin2" runat="server" FilterType="Custom,Numbers"
                                        TargetControlID="txtNAMin2">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:RangeValidator ID="rangetxtNAHr2" runat="server" ControlToValidate="txtNAHr2" MinimumValue="0"
                                        MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                                    <asp:RangeValidator ID="rangetxttxtNAMin2" runat="server" ControlToValidate="txtNAMin2"
                                        MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblNADate" runat="server" Text='<%#Eval("NADate") %>'></asp:Label>
                                     <asp:Label ID="lblNACentreID" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <AlternatingRowStyle CssClass="GridViewItemStyle" />
                    </asp:GridView>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:CheckBox ID="chkLogin" runat="server" Text="Login Required" onClick="ShowText();"
                            ToolTip="Check Login Required " />
                    </label>
                </div>
                <div class="col-md-5">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Digital Signature
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:FileUpload ID="fuDrSignature" runat="server" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Room No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtRoomNo" runat="server" TabIndex="28" Width="44px"
                        ToolTip="Enter Room No."></asp:TextBox>
                    Floor :&nbsp;<asp:DropDownList ID="ddlDocFloor" TabIndex="29" runat="server" Width="126px"></asp:DropDownList>
                </div>
            </div>
            <asp:Panel ID="pnlLogin" runat="server" Style="display: none">
            <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            User Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Password
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox
                            ID="txtPassword" TextMode="Password" runat="server" MaxLength="20"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            <asp:Label ID="TextBox1_HelpLabel" runat="server" Style="display: none" />
                            Confirm Password
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtConfirmpwd" runat="server" Font-Bold="true" TextMode="Password" Style="position: static"
                            MaxLength="20"></asp:TextBox>
                    </div>
                
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align:center">
                   <asp:Label ID="Lbl_Helplabel" runat="server" Font-Bold="true" BackColor="Yellow" ForeColor="Red" /></div>
            </div></asp:Panel>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:UpdatePanel ID="UP5" runat="server">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                TabIndex="30" Text="Save" ToolTip="Click To Save" OnClientClick="return validateDoc()" />
                </ContentTemplate>
            </asp:UpdatePanel>
            
        </div>
    <%--    <cc1:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="txtPassword"
            DisplayPosition="BelowLeft" StrengthIndicatorType="Text" PreferredPasswordLength="6"
            PrefixText="Strength: " TextCssClass="TextIndicator_TextBox3" HelpStatusLabelID="TextBox1_HelpLabel"
            TextStrengthDescriptions="Very Poor;Weak;Average;Strong;Excellent" HelpHandleCssClass="TextIndicator_TextBox3_Handle"
            HelpHandlePosition="LeftSide" />--%>
         <cc1:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="txtPassword" ValidateRequestMode="Disabled" 
                DisplayPosition="AboveLeft"
                StrengthIndicatorType="Text"
                PreferredPasswordLength="6"
                PrefixText="Strength: "
                TextCssClass="TextIndicator_TextBox3"
                HelpStatusLabelID="Lbl_Helplabel"
                TextStrengthDescriptions="VeryPoor;Weak;Average;Strong;Excellent"
                TextStrengthDescriptionStyles="VeryPoor;Weak;Average;Excellent;Strong"
                MinimumLowerCaseCharacters="0"
                MinimumUpperCaseCharacters="0"
                MinimumSymbolCharacters="0"
                RequiresUpperAndLowerCaseCharacters="false"
                BarBorderCssClass="border" 
                />
         <style type="text/css">
      .VeryPoor
       {
         background-color:red;
       color:white;
       font-weight:bold;
         }

          .Weak
        {
         background-color:orange;
         color:white;
       font-weight:bold;
         }

          .Average
         {
          background-color: #A52A2A;
          color:white;
       font-weight:bold;
         }
          .Excellent
         {
         background-color:yellow;
         color:white;
       font-weight:bold;
         }
          .Strong
         {
         background-color:green;
         color:white;
       font-weight:bold;
         }
          .border
         {
          border: medium solid #800000;
          width:500px;                
         }
      </style>
    </div>
     
    <script type="text/javascript">
        $('#ddlDoctor').change(function () {
            // check selected
            if ($(this).find('option:selected').val() == '0')
                return false;

            var id = $(this).find(':selected').val(), dname = $(this).find(':selected').text(), position = $('#ddlPosition').find(':selected').text();
            var doc = { docID: id, docName: dname, docPosition: position }

            //addUnitDoctor(doc, function () {
            //    showHideDoctorList("s");
            //});

           // if ($('#<%=rblDocShare.ClientID%>' + '_0').is(':checked')) {
            //    addUnitDoctor(doc, function () {
            //        showHideDoctorList("s");
            //    });
            //}
            //else {
            //    bindAdmissionDoctors(doc, function () {
            //        showHideDoctorList("n");
            //    });
            //}

        });

        var isDocAdded = function (docId, ob) {
            var isExist = $(ob).find('#' + docId)
            if (isExist.length > 0)
                return true
        }
        var DocID = "";
        var bindAdmissionDoctors = function (doc, callback) {
            var docList = $('#divDoctorList')
            if (isDocAdded(doc.docID, docList.find('#ulDocyorList'))) {
                modelAlert('Doctor Already Selected')
                return false;
            }
           // $('#<%=txtUnitDoctorList.ClientID%>').val(DocID + ",");
            docList.find('ul').append('<li id=' + doc.docID + ' class="search-choice"><span>' + doc.docName + '</span><a onclick="onRemoveFromList(this)" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + doc.docID + '</a></li>');
            callback();
        }

        var onRemoveFromList = function (ob) {
            $(ob).parent().remove()
        }

        $(function () {
            $('#<%=rblDocShare.ClientID%>' + '_0').change(function () {
                if ($('#<%=ddldoctorgroup.ClientID%>').find(':selected').val() == "4") {
                    addDoctorToTable();
                    showHideDoctorList("s");
                    $('#lblPosition').css("display", "");
                    $('#ddlPosition').css("display", "");
                }
            })

            $('#<%=rblDocShare.ClientID%>' + '_1').change(function () {
                if ($('#<%=ddldoctorgroup.ClientID%>').find(':selected').val() == "4") {
                    addDoctorToList();
                    showHideDoctorList("n");
                }
              //  $('#divDoctorname').css("display", "none");
                //$('#lblPosition').css("display", "none");
                //$('#ddlPosition').css("display", "none");

                $('#lblPosition').css("display", "");
                $('#ddlPosition').css("display", "");
            })
        });

        var addDoctorToTable = function () {

            $('#ulDocyorList').find('li').each(function () {
                var docId = $(this).attr('id')
                if (!isDocAdded(docId, $('#tblDoctorList'))) {
                    var doctorList = {
                        docID: docId,
                        docName: $(this).find('span').text(),
                        docPosition: "Senior"
                    }
                    addUnitDoctor(doctorList, function () { })
                }
            })
            showHideDoctorList("s");
        }

        var addDoctorToList = function () {
            $('#tblDoctorList tbody').find('tr').each(function (i) {
                var doc = {
                    docID: $(this).attr('id'),
                    docName: $(this).find('#docName_' + (++i) + '').text()
                }
                //if (!isDocAdded(doc.docID, $('#ulDocyorList'))) {
                //    bindAdmissionDoctors(doc, function () { showHideDoctorList("n") });
                //}
            });

            showHideDoctorList("n");
        }

        var showHideDoctorList = function (type) {
            //if (type == "s") {
                $('#tblDoctorList').css("display", "");
                $('#ulDocyorList').css("display", "none");
                $('#divDoctorList').css("display", "");
                $('#divDoctorname').css("display", "");
            //}
            //else {
            //    $('#tblDoctorList').css("display", "none");
            //    $('#ulDocyorList').css("display", "");
            //    $('#divDoctorname').css("display", "");
            //    $('#divDoctorList').css("display", "");

            //}
        }

        var addUnitDoctor = function (doc, callback) {

            if (isDocAdded(doc.docID, $('#tblDoctorList'))) {
                modelAlert('Doctor Already Selected')
                return false;
            }
            // Add table header
            var tHead = $('#tblDoctorList thead')
            if (tHead.find('tr').length == 0) {
                var tHeadContent = '<tr>'
                tHeadContent += '<td style="width:20px">S.No.</td>'
                tHeadContent += '<td style="width:300px">Name</td>'
                tHeadContent += '<td style="width:100">Position</td>'
                tHeadContent += '<td></td>'
                tHeadContent += '</tr>'
                tHead.append(tHeadContent);
            }
            // Add table data 

            var tBody = $('#tblDoctorList tbody')
            var i = tBody.find('tr').length;
            var gname = 'sharetype_' + ++i;
            var tBodyContent = '<tr id=' + doc.docID + ' tableid=' + i + '>'
            tBodyContent += '<td>' + i + '</td>'
            tBodyContent += '<td id="docName_' + i + '">' + doc.docName + '</td>'
            tBodyContent += '<td id="docPos_' + i + '"><span id="spnDocPos">' + doc.docPosition + '</span></td>'
            tBodyContent += '<td style="display:none;"><input type="text" id="txtDoctorID_' + i + '" value=' + doc.docID + ' /></td>'
            tBodyContent += '<td><input type="button" value="Remove"  onclick="onRemoveDoctor(this)" class="ItDoseButton" /></td>'
            tBodyContent += '</tr>'
            tBody.append(tBodyContent);

            callback()
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

        $getDoctorShareDetails = function (callback) {
            $data = new Array();

            $('#tblDoctorList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('tableid');
                $data.push({
                    DoctorListId: $(this).closest('tr').attr('id'),
                    Position: $(this).closest('tr').find("#spnDocPos").text()
                });
            });
            callback($data);
        }

      //  $('#<%=ddldoctorgroup.ClientID%>').change(function () {
        //    var docType = $(this).find('option:selected').val();
          //  if (docType == "4") {
            //    $("#rbUnit").prop("checked", true);
              //         $("#divDoctorname").css("display", "");
                //       if ($('#ddlDoctor option').length > 0) {
                  //         $("#lbldoctor").css("display", "");
                    //       $("#divDoctor").css("display", "");
                      // }
                      // if ($('#<%=rblDocShare.ClientID%>' + '_0').is(':checked')) {
                             $("#ddlPosition").css("display", "");
                             $("#lblPosition").css("display", "");
                       //  }
                     //}
                     //else {
                //$("#rbSingle").prop("checked", true);
                  //     $("#lbldoctor").css("display", "none");
                    //   $("#divDoctor").css("display", "none");
                      // $("#divDoctorname").css("display", "none");
                       //$("#ddlPosition").css("display", "none");
                       //$("#lblPosition").css("display", "none");
                  // }

        //})
    </script>
    
</asp:Content>
