<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="HospitalMaster.aspx.cs" Inherits="Design_EDP_HospitalMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript"  src="../../Scripts/jquery-1.4.2.min.js"></script>
   <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >

        function chkHos() {
            if ($.trim($("#txtName").val()) == "") {
                $("#lblMsg").text('Please Enter Name');
                $("#txtName").focus();
                return false;
            }
            if ($.trim($("#txtFullName").val()) == "") {
                $("#lblMsg").text('Please Enter Full Name');
                $("#txtFullName").focus();
                return false;
            }
            if ($.trim($("#txtAddress").val()) == "") {
                $("#lblMsg").text('Please Enter Address');
                $("#txtAddress").focus();
                return false;
            }
            if ($.trim($("#txtContactNo").val()) == "") {
                $("#lblMsg").text('Please Enter Contact No.');
                $("#txtContactNo").focus();
                return false;
            }
            if ($.trim($("#txtEmailID").val()) == "") {
                $("#lblMsg").text('Please Enter Email ID');
                $("#txtEmailID").focus();
                return false;
            }

            if ($.trim($("#txtWebSite").val()) == "") {
                $("#lblMsg").text('Please Enter WebSite');
                $("#txtWebSite").focus();
                return false;
            }
            if ($.trim($("#txtReportHeader").val()) == "") {
                $("#lblMsg").text('Please Enter Report Header');
                $("#txtReportHeader").focus();
                return false;
            }
            if ($('#chkDoctorVisit').is(':checked')) {
                if ($('#ddlDoctorSubID').val() == 0)
                {
                    $("#lblMsg").text('Please Select Doc. Visit Subcategory');
                    $("#ddlDoctorSubID").focus();
                    return false;
                }
            }
            
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
        </script>

    <script type="text/javascript">
        function checkFinYear() {
            if ($("#chkFinYear").is(':checked'))
                $("#txtFinYear").removeAttr('disabled');
            else
                $("#txtFinYear").val('').attr('disabled', 'disabled');
            GeneratePreview();
        }
        function Extender_Onchange(sender, args) {
            GeneratePreview();
        }

        function GeneratePreview() {
            if (Page_ClientValidate() == false) {
                $('#lblPreview').text('');
                return;
            }
            $('#ddlSeparator2 option[value="' + $('#ddlSeparator1').val() + '"]').attr('selected', true);
            var initial = $('#txtInitial').val().toUpperCase();
            var Separator1 = $('#ddlSeparator1').val();
            var FinYear = "";
            if ($.trim($('#txtFinYear').val()) != "")
                 FinYear = GetFinancialYear();
            var Separator2 = $('#ddlSeparator2').val();
            var Length = $('#ddlLength option:selected').text();
            $('#lblPreview').text(initial + Separator1 + FinYear + Separator2 + Length);
            if ($('#lblPreview').text() == "")
                $('#btnSaveFromat').attr("disabled", true);
            else
                $('#btnSaveFromat').removeAttr("disabled");
        }
        function GetFinancialYear() {
            var data;
            $.ajax({
                url: "Services/EDP.asmx/GetFinYear",
                data: '{date:"' + $('#txtFinYear').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    data = mydata.d;

                }
            });
            return data;
        }
        function SaveFormat() {
            if (Page_ClientValidate() == false) {
                $('#lblPreview').text('');
                return;
            }
            if (($("#chkFinYear").is(':checked')) && ($.trim($('#txtInitial').val())=="")) {
                return;
            }
            if ($('#ddlCenter').val() == 0)
            {
                modelAlert("Please Select Center", function () { $('#ddlCenter').focus() });
                return;
            }
            $('#btnSaveFromat').attr('disabled', 'disabled');
            var data = new Array();
            var Obj = new Object();
            Obj.CenterID = $('#ddlCenter').val();
            Obj.Typename = $('#ddlType option:selected').text();
            Obj.formatID = $('#ddlType').val();
            Obj.InitialChar = $('#txtInitial').val().toUpperCase();
            if ($('#txtFinYear').val() != "") {
                Obj.FinYear = $('#txtFinYear').val();
                Obj.chkFinancialYear = "1";
            }
            else {
                Obj.FinYear = "0001-01-01";
                Obj.chkFinancialYear = "0";
            }
            Obj.Separator1 = $('#ddlSeparator1').val();
            Obj.Separator2 = $('#ddlSeparator2').val();
            Obj.Length = $('#ddlLength').val();
            Obj.FormatPreview = $('#lblPreview').text();
            data.push(Obj);

            $.ajax({
                url: "Services/EDP.asmx/SaveFormat",
                data: JSON.stringify({ FormatDetail: data }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    data = mydata.d;
                    if (data == "1") {
                        alert("Record Save Successfully");
                        Bind_id_master_format();
                        ClearFormat();
                    }
                    else {
                        alert("Error");
                    }
                }
            });
            $('#btnSaveFromat').removeAttr('disabled');

        }
        function ClearFormat() {
            $('#ddlType option[value="0"]').attr('selected', true);
            $('#txtInitial').val('');
            $('#txtFinYear').val('');
            $('#lblPreview').text('');
        }
        function Bind_id_master_format() {
            $.ajax({
                url: "Services/EDP.asmx/Bind_id_master_format",
                data: '',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        var output = $('#tb_id_master_format').parseTemplate(data);

                        $('#id_master').html(output);
                    }
                }
            });
        }
        $(document).ready(function () {
            $('#btnSaveFromat,#txtFinYear').attr("disabled", true);
            Bind_id_master_format();

            $("#txtInitial").bind("click keyup change", function () { GeneratePreview(); });
            $("#txtFinYear").bind("click keyup change", function () { GeneratePreview(); });
            $("#ddlSeparator1").bind("click change", function () { GeneratePreview(); });
            $("#ddlSeparator2").bind("click change", function () { GeneratePreview(); });
            $("#ddlLength").bind("click change", function () { GeneratePreview(); });
            $('#calendar1_container').bind("click change", function () { GeneratePreview(); });
            Show();
        });
        function bindFormat() {


        }
        function Show()
        {
            if ($('#chkDoctorVisit').is(':checked'))
                $('#ddlDoctorSubID').show();
            else
                $('#ddlDoctorSubID').hide();
        }
    </script>
     <div id="Pbody_box_inventory">
         <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
            <b>Hospital Master</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Hospital Details
            </div>
            <table style="width: 100%; border-collapse:collapse">
                <tr>
                    <td style="width: 42%;text-align:right" >Name :&nbsp;</td>
                    <td style="width: 58%;text-align:left" >
                        <asp:TextBox ID="txtName" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Application URL Name :&nbsp;</td>
                    <td style="width: 58%;text-align:left" >
                        <asp:TextBox ID="txtApplicationURLName" ClientIDMode="Static" runat="server" Width="500px" MaxLength="10"></asp:TextBox>
                        <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Full Name :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtFullName" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right; vertical-align:top" >Address :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtAddress" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="500px" MaxLength="100"></asp:TextBox>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                    </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Contact No. :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtContactNo" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Email ID :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtEmailID" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >WebSite :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtWebSite" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Logo :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:FileUpload ID="fuLogo" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Other Details
            </div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="width: 42%;text-align:right" >Report Header :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:TextBox ID="txtReportHeader" ClientIDMode="Static" runat="server" Width="500px" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Logo For Crystal Report Portrait Page (A4) :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:FileUpload ID="fuLogoCrystalReport" runat="server" />
                    &nbsp;<span style="color: #0066FF">(Image Size width:7.5&quot; &amp; Height:2&quot;)</span></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Default Country :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:Label ID="lblDefaultCountry" runat="server"></asp:Label>
                        <asp:Label ID="lblBaseCurrencyID" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Default City :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlDefaultCity" runat="server"  Width="140px">
                        </asp:DropDownList>
                    </td>
                    </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Base Currency :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:Label ID="lblBaseCurrency" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Language  :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlLanguage" runat="server" Width="140px">
                            <asp:ListItem Text ="English" Value="en-US"></asp:ListItem>
                            <asp:ListItem Text ="French" Value="fr-FR"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Pathology Category :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlPathologyCategoryID" runat="server" Width="140px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Radiology Category :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlRadiologyCategoryID" runat="server" Width="140px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >OPD Appointment Category :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlOPDAppointmentCategoryID" runat="server" Width="140px">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Default Panel :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:DropDownList ID="ddlDefaultPanel" runat="server" Width="140px">
                        </asp:DropDownList></td>
                </tr>

                <tr>
                    <td style="width: 42%;text-align:right" >Application Run Centre Wise :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:RadioButtonList ID="rblApplicationRun" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  ></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>

                <tr>
                    <td style="width: 42%;text-align:right" >OPD Old Patient Button Visible :&nbsp;</td>
                    <td style="width: 58%;text-align:left">
                        <asp:RadioButtonList ID="rblOPDOldPatient" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="block" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="none"  ></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Patient Demographics info. Read Only :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblPatientDemographics" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="true" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="false" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >Notification Display :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblNotification" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="block" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="none"  ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >TaxRequired :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblTaxRequired" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >OPD Card :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblOPDCard" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >Generate Bill and Receipt from Same Screen :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblReceiptGenerate" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >Show Patient Photo :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblPatientPhoto" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Show Patient Outstanding :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblPatientOutstanding" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >IPD Bill Finalised :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblIPDBillFinalised" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >SMS Applicable :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblSMSApplicable" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>
                 <tr>
                    <td style="width: 42%;text-align:right" >Token Display Window :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblTokenDisplay" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>

                 <tr>
                    <td style="width: 42%;text-align:right" >RegistrationCharges Applicable :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblRegistrationChargesApplicable" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>

                 <tr>
                    <td style="width: 42%;text-align:right" >HospitalCharges Applicable :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:RadioButtonList ID="rblHospitalChargesApplicable" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Yes" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"  Selected="True" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                </tr>

                <tr>
                    <td style="width: 42%;text-align:right" >Set Registration Item :&nbsp</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlRegistration" runat="server" Width="140px"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Set OT Item :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlOTItem" runat="server" Width="140"></asp:DropDownList>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >Prescribe Item On Admission Time :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:CheckBox ID="chkAdmissionRoom" Text="Room Charges" runat="server" />&nbsp;<asp:CheckBox ID="chkDoctorVisit" Text="Doctor Visit Charges" runat="server" ClientIDMode="Static" onclick="Show()" /><asp:DropDownList ID="ddlDoctorSubID" runat="server" Width="120px" ClientIDMode="Static"></asp:DropDownList>&nbsp;<asp:CheckBox ID="chkAdmissionCharges" Text="Admission Charges" runat="server" /></td>
                </tr>
                <tr>
                    <td style="width: 42%;text-align:right" >&nbsp;</td>
                    <td style="width: 58%;text-align:left">&nbsp;</td>
                </tr>
                </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Cache Time Out Details
            </div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="width: 43%; text-align:right" >Country Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlCountryCache" runat="server" >
                       
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                                           </asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="width: 43%; text-align:right" >City Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlCityCache" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="width: 43%; text-align:right" >Doctor Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlDoctorCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >General Store GRN Items Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlGeneralStoreGRNCache" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Medical Store GRN Items Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlMedicalStoreGRNCache" runat="server">
                       <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >General Store PR Items Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlGeneralStoreCachePR" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Medical Store PR Items Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlMedicalStoreCachePR" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >OPD&nbsp;Investigation,Procedure&nbsp;&amp;&nbsp;Other&nbsp;Items&nbsp;Cache&nbsp;Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlOPDInvCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >OPD Panel Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlOPDPanelCache" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >IPD Panel Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlIPDPanelCache" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Refer Doctor Cache Timeout :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlReferDocCache" runat="server">
                        <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        
                                           </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Category Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlCategoryCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                         </asp:DropDownList>
                        </td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >SubCategory Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlSubCategoryCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                         </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >AppointmentType Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlAppointmentTypeCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                         </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Bank Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlBankCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                         </asp:DropDownList></td>
                </tr>
               
                <tr>
                    <td style="width: 43%; text-align:right" >Currency Cache TimeOut :&nbsp;</td>
                    <td style="width: 58%;text-align:left"><asp:DropDownList ID="ddlCurrencyCache" runat="server">
                         <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                        <asp:ListItem  Value="120" Text="120 min"></asp:ListItem>
                        <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                        <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                         </asp:DropDownList></td>
                </tr>
               
                </table>
        </div>
         <div class="POuter_Box_Inventory">
           
            <table style="width: 100%">
                <tr>
                    <td style="width: 100%;text-align:center" >
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return chkHos();" />
                    </td>
                    
                </tr>
                
              
               
                </table>
        </div>

          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Receipt & Bill Format
            </div>
              <table style="width: 100%; ">
                  <tr>
                      
                      <td style="width: 78%" colspan="2">
                          <table style="width:100%"  >
                              <tr>
                                  <td class="GridViewHeaderStyle">Center</td>
                                  <td class="GridViewHeaderStyle">Type</td>
                                  <td class="GridViewHeaderStyle">Initial Character&nbsp;&nbsp;</td>
                                  <td class="GridViewHeaderStyle">Separator&nbsp;</td>
                                  <td class="GridViewHeaderStyle">Financial Year Start&nbsp;</td>
                                  <td class="GridViewHeaderStyle">Separator&nbsp;</td>
                                  <td class="GridViewHeaderStyle">Length&nbsp;</td>
                                  <td class="GridViewHeaderStyle">&nbsp;&nbsp;Preview&nbsp;&nbsp;</td>
                                  
                                  <td></td>
                                  
                              </tr>
                              <tr>
                                   <td class="GridViewItemStyle"><asp:DropDownList ID="ddlCenter" runat="server" ClientIDMode="Static"></asp:DropDownList></td>
                                  <td class="GridViewItemStyle" style="width:200px">
                              <asp:DropDownList ID="ddlType" runat="server">
                                 <%-- <asp:ListItem Value="0">Select</asp:ListItem>
                              <asp:ListItem>Receipt No.</asp:ListItem>
                              <asp:ListItem>OPD Bill No.</asp:ListItem>
                                  <asp:ListItem>IPD Bill No.</asp:ListItem>
                                  <asp:ListItem>General Store PR No.</asp:ListItem>
                                  <asp:ListItem>Medical Store PR No.</asp:ListItem>
                                  <asp:ListItem>Purchase Order No.</asp:ListItem>
                                  <asp:ListItem>Store Issue Bill No.</asp:ListItem>
                                  <asp:ListItem>Store Return Bill No.</asp:ListItem>
                                  <asp:ListItem>Panel Invoice</asp:ListItem>--%>
                          </asp:DropDownList>
                                      <asp:RequiredFieldValidator ID="reqtxtInitial0" runat="server" Display="Static" ErrorMessage="*" ControlToValidate="ddlType" ForeColor="Red" SetFocusOnError="True" InitialValue="0"></asp:RequiredFieldValidator>
                                  &nbsp;</td>
                                  <td class="GridViewItemStyle">
                                      <asp:TextBox ID="txtInitial" runat="server" MaxLength="6" onChange="GeneratePreview()" Width="80px"></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="reqtxtInitial" runat="server" Display="Static" ErrorMessage="*" ControlToValidate="txtInitial" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                  </td>
                                  <td class="GridViewItemStyle"><asp:DropDownList ID="ddlSeparator1" Width="40px" runat="server">
                                      <asp:ListItem Value=""></asp:ListItem>
                              <asp:ListItem Value="/">/</asp:ListItem>
                              <asp:ListItem Value="-">-</asp:ListItem>
                          </asp:DropDownList></td>
                                  <td class="GridViewItemStyle">
                                      <asp:CheckBox ID="chkFinYear" runat="server" onclick="checkFinYear()" />
                                      <asp:TextBox ID="txtFinYear" runat="server"    Width="120px"></asp:TextBox>
<%--                                      <asp:RequiredFieldValidator ID="reqtxtInitial1" runat="server" Display="Static" ErrorMessage="*" ControlToValidate="txtFinYear" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                    <cc1:CalendarExtender ID="CalendarExtender1" OnClientDateSelectionChanged="Extender_Onchange" BehaviorID="calendar1" runat="server"  TargetControlID="txtFinYear" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                                  </td>
                                  <td class="GridViewItemStyle"><asp:DropDownList ID="ddlSeparator2" Width="40px" runat="server">
                                      <asp:ListItem Value=""></asp:ListItem>
                              <asp:ListItem>/</asp:ListItem>
                              <asp:ListItem>-</asp:ListItem>
                          </asp:DropDownList></td>
                                  <td class="GridViewItemStyle">
                               <asp:DropDownList ID="ddlLength" runat="server">
                              <asp:ListItem Selected="True" Value="6">000001</asp:ListItem>
                              <asp:ListItem Value="7">0000001</asp:ListItem>
                              <asp:ListItem Value="8">00000001</asp:ListItem>
                              <asp:ListItem Value="9">000000001</asp:ListItem>
                              <asp:ListItem Value="10">0000000001</asp:ListItem>
                              <asp:ListItem Value="11">00000000001</asp:ListItem>
                              <asp:ListItem Value="12">000000000001</asp:ListItem>
                          </asp:DropDownList></td>
                                  <td class="GridViewItemStyle">
                                      <asp:Label ID="lblPreview" runat="server"></asp:Label>
                                  </td>
                                  <td>
                                      &nbsp;&nbsp;
                                      <input type="button" value="Save" onclick="SaveFormat()"  id="btnSaveFromat" class="ItDoseButton" />&nbsp;&nbsp;&nbsp;
                                  </td>
                                  
                              </tr>
                          </table>
                      </td>
                   </tr>
                <tr>
                    <td style="width: 42%; text-align: right">&nbsp;</td>
                      <td style="width: 58%">

                          
                      </td>
                  </tr>
                <tr>
                    <td style="text-align: center" colspan="2">
                        <div id="id_master"></div>
                        &nbsp;</td>
                  </tr>
              </table>
        </div>
        
    </div>
<script id="tb_id_master_format" type="text/html">
    <table  id="id_master_format"  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse; ">
        <thead>
		<tr id="Header">
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;text-align:left">Center</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;text-align:left">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left">Initial Character</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center">Separator1</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px; text-align:left">Financial Year Start</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px; text-align:center">Separator2</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px; text-align:left">Length</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;text-align:left">Preview</th>
		</tr>
            </thead>
        <tbody>
            <#                
        for(var j=0;j<data.length;j++)
        {       
       var objRow = data[j];
        #>
                        <tr>
                        <td  class="GridViewLabItemStyle" style="width:120px;text-align:left"><#=objRow.CentreName#></td>
                        <th class="GridViewLabItemStyle" style="width:120px;text-align:left"><#=objRow.TypeName#></th>
                        <td class="GridViewLabItemStyle" style="width:80px;text-align:left"><#=objRow.InitialChar#></td>
                        <td class="GridViewLabItemStyle" style="width:40px;text-align:center"><#=objRow.Separator1#></td>
                        <td class="GridViewLabItemStyle" style="width:120px;text-align:left"><#=objRow.FinancialYearStart#></td>
                        <td class="GridViewLabItemStyle" style="width:40px;text-align:center"><#=objRow.Separator2#></td>
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:left"><#=objRow.TypeLength#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:left"><#=objRow.FormatPreview#></td>   
                              </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
    
    </script>

    </asp:Content>