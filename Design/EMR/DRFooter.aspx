<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DRFooter.aspx.cs" Inherits="Design_EMR_DRFooter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Discharge Report Footer</title>    
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <%--<link href="../../Styles/framestyle.css" rel="stylesheet" />
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>--%>
    
    <script type="text/javascript">
        var TID = '<%=Util.GetString(ViewState["TID"])%>';
        function addConsultant() {
            if ($("#<%=ddldoctor.ClientID %>").val() != "0") {
                if (TID != "") {
                    var isMainDoctor = $("#chkIsMainDoctor").is(':checked') ? 1 : 0;
                    $("#btnAdd").prop('disabled', 'disabled');
                    $.ajax({
                        type: "POST",
                        data: '{DoctorID:"' + $("#<%=ddldoctor.ClientID %>").val() + '",TID:"' + TID + '",IsMainDoctor:"' + isMainDoctor + '",doctorName:"' + $("#ddldoctor option:selected").text() + '"}',
                        url: "Services/EMR.asmx/ConsultantAdd",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            if (result.d == "1") {
                                $("#<%=lblMsg.ClientID %> ").text('Record Saved Successfully');
                                $("#btnAdd").removeProp('disabled', 'disabled');
                                bindConsultant();
                            }
                            else if (result.d == "0") {
                                $("#<%=lblMsg.ClientID %> ").text('Consultant Already Exist');
                                    $("#btnAdd").removeProp('disabled', 'disabled');
                                    bindConsultant();
                                }
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                            $("#btnAdd").removeProp('disabled', 'disabled');
                        }
                    });
                }
            }
            else {
                $("#<%=lblMsg.ClientID %> ").text('Please Select Consultant');
                $("#<%=ddldoctor.ClientID %>").focus();
            }
        }

        function bindConsultant() {
            $.ajax({
                type: "POST",
                data: '{TID:"' + TID + '"}',
                url: "Services/EMR.asmx/bindConsultant",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    EMRData = jQuery.parseJSON(result.d);
                    if (EMRData != null) {
                        var output = $('#tb_EMRSearch').parseTemplate(EMRData);
                        $('#EMRSearchOutput').html(output);
                        $('#EMRSearchOutput').show();
                    }
                    else {
                        $('#EMRSearchOutput').html();
                        $('#EMRSearchOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                    $("#btnAdd").removeProp('disabled', 'disabled');
                }
            });
        }

        $(document).ready(function () {
            bindConsultant();
        });

        function DeleteConsultant(rowid) {
            var DoctorID = $(rowid).closest('tr').find('#tddoctorID').text();
            var TID = $(rowid).closest('tr').find('#tdTransactionID').text();
            var master = Number($(rowid).closest('tr').find('#tdMaster').text());

            $.ajax({
                type: "POST",
                data: '{TID:"' + TID + '",DoctorID:"' + DoctorID + '",Master:"' + master + '"}',
                url: "Services/EMR.asmx/DeleteConsultant",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        $("#<%=lblMsg.ClientID %> ").text('Record Deleted Successfully');
                        bindConsultant();
                    }
                    else if (result.d == "2") {
                        $("#<%=lblMsg.ClientID %> ").text('Atleast One Main Doctor Required !!!');
                        // bindConsultant();
                    }
                    else {
                        $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                        bindConsultant();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                }
            });
        }

        function chngcur() {
            document.body.style.cursor = 'pointer';
        }

        function Save() {
            $("#btnSave").prop('disabled', 'disabled');
            $.ajax({
                type: "POST",
                data: '{TID:"' + TID + '",Footer:"' + decodeURIComponent($("#<%=txtDetail.ClientID %> ").val()) + '",PreparedBy:"' + decodeURIComponent($("#<%=txtPreparedBy.ClientID %> ").val()) + '"}',
                url: "Services/EMR.asmx/saveEmrFooter",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        $("#<%=lblMsg.ClientID %> ").text('Record Saved Successfully');
                        $("#btnSave").removeProp('disabled');
                    }
                    else {
                        $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                        $("#btnSave").removeProp('disabled');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                    $("#btnSave").removeProp('disabled');
                }
            });
        }

        var characterLimit = 500;
        $("#<% =txtDetail.ClientID %>").bind("cut copy paste", function (event) {
            event.preventDefault();
        });

        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit - ($("#<%=txtDetail.ClientID %>").val().length));
            $("#<%=txtDetail.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">                              
                <b>Discharge Report Footer</b><br />                                                            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />                                  
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Add Consultant :&nbsp;
                </div>              
                <table cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td style="width: 15%; text-align:right">Add Consultant :&nbsp;</td>
                        <td style="width: 85%">
                            <asp:DropDownList ID="ddldoctor" ClientIDMode="Static" runat="server" Width="271px"></asp:DropDownList> &nbsp; &nbsp; 
                            <input type="checkbox" id="chkIsMainDoctor" /> Main Doctor &nbsp; &nbsp;
                            <input type="button" id="btnAdd" value="Add" class="ItDoseButton" onclick="addConsultant()" />
                        </td>                            
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center; height: 16px;"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left"></td>
                    </tr>
                </table>
                <div class="Purchaseheader">
                    Consultant Details Found
                </div>
                <div>
                    <table>
                        <tr>
                            <td style="text-align: right; width: 647px;">&nbsp;</td>
                            <td colspan="2" style="text-align: left">
                                <table style="width: 150%;">
                                    <tr>
                                       <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;border-left: black thin solid; border-bottom: black thin solid; background-color:yellow;">
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td style="text-align:left">
                                            Main Doctors
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="text-align: left; width: 730px;"></td>
                        </tr>
                    </table>
                </div>
                <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                    <tr style="b">
                        <td colspan="4">
                            <div id="EMRSearchOutput" style="max-height: 500px; overflow-x: auto;">
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="Purchaseheader" style="display:none">
                    Prepared By 
                </div>               
                <table cellpadding="0" cellspacing="0" style="width: 100%;display:none" >
                    <tr>
                        <td  style="width: 15%; text-align:right">Prepared By :</td>
                        <td style="width: 85%">
                            <asp:TextBox ID="txtPreparedBy" runat="server" Width="543px" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center; height: 16px;"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left"></td>
                    </tr>
                </table>
                <div class="Purchaseheader" style="display:none">
                    Enter Footer Text 
                </div>                    
                <table cellpadding="0" cellspacing="0" style="width: 100%;display:none">
                    <tr>
                        <td style="width: 15%; text-align:right"></td>
                        <td style="width: 85%"></td>
                    </tr>
                    <tr>
                        <td  colspan="2" style="text-align: center">
                            <asp:TextBox ID="txtDetail" runat="server" Height="50px" TextMode="MultiLine" Width="635px"></asp:TextBox>Number of Characters Left:
                            <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;"></label>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2" style="text-align: left"></td>
                    </tr>
                </table>              
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center;display:none">
                   <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="Save()" />
            </div>
       </div>
    <script id="tb_EMRSearch" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch" style="width:100%;border-collapse:collapse; text-align:center">
		    <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px; text-align:center">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none">IPD No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;text-align:center;">Doctor Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Doctor ID</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">TID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Master</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Remove</th>            
		    </tr>
            <#       
            var dataLength=EMRData.length;
            window.status="Total Records Found :"+ dataLength;
            var objRow;   
            var status;     
            for(var j=0;j<dataLength;j++)
            {       
            objRow = EMRData[j];
            #>
            <tr id="<#=j+1#>"  
            <#if(objRow.Master=="1"){#>
                style="background-color:yellow"
            <#}#>>                             
                <td class="GridViewLabItemStyle"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdTID"  style="width:40px; text-align:center;display:none" ><#=objRow.TID#></td>
                <td class="GridViewLabItemStyle" id="tdName" style="width:280px; text-align:left"><#=objRow.Name#></td>
                <td class="GridViewLabItemStyle" id="tddoctorID" style="width:40px;display:none"><#=objRow.doctorID#></td>
                <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:140px;display:none"><#=objRow.TransactionID#></td>
                <td class="GridViewLabItemStyle" id="tdMaster" style="width:140px;display:none"><#=objRow.Master#></td>
                <td class="GridViewLabItemStyle" id="tdRemove" style="width:30px;">
                <#if(objRow.IsUpdate =="1"){#>             
                    <img alt="Select" onclick="DeleteConsultant(this);" onmouseover="chngcur()" id="btnDelete" src="../../Images/Delete.gif" style="border: 0px solid #FFFFFF;"/>
                <#}
                else
                {#>                  
                    <img alt="Select" onclick="DeleteConsultant(this);" onmouseover="chngcur()" id="Img1" src="../../Images/Delete.gif" style="border: 0px solid #FFFFFF; display:none;"/>
                <#}#>
                </td>
            </tr>            
            <#}#>       
        </table>    
    </script>
    </form>
</body>
</html>
