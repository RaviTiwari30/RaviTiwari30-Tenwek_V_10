<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="HelpDeskDoctor.aspx.cs" Inherits="Design_HelpDesk_HelpDeskDoctor" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
         <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >

      
        function searchDoctor() {
            $("#lblMsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/searchDoctor",
                data: '{Department:"' + $.trim($("#ddlDepartment option:selected").text()) + '",Name:"' + $.trim($("#txtName").val()) + '",ContactNo:"' + $.trim($("#txtMobile").val()) + '",Specialization:"' + $.trim($("#ddlSpecialization option:selected").text()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    doctor = jQuery.parseJSON(response.d);
                    if (doctor != null) {
                        var output = $('#tb_searchDoctor').parseTemplate(doctor);
                        $('#DoctorOutput').html(output);
                        $('#DoctorOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblMsg');
                        $('#DoctorOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        </script>
    <script type="text/javascript">
        function PrintDoctorSticker(rowid) {
            var NoofPrint = $(rowid).closest('tr').find("#txtPrint").val();
            var DoctorName = $(rowid).closest('tr').find("#tdDoctorName").text();
            var Department = $(rowid).closest('tr').find("#tdDepartment").text();
            var Degree = $(rowid).closest('tr').find("#tdDegree").text();
            var data = "";
            if (NoofPrint != 0 && NoofPrint != "") {
                var Ok = confirm("Do you Want To Print (" + NoofPrint + ") Sticker of " + DoctorName);
                if (Ok == true) {
                    //var DoctorID = $(rowid).closest('tr').find("#tdDoctorID").text();
                    //$.ajax({
                    //    url: "Services/HelpDesk.asmx/PrintDoctorSticker",
                    //    data: '{DoctorID:"' + DoctorID + '",NoofPrint:"' + NoofPrint + '"}',
                    //    type: "Post",
                    //    contentType: "application/json; charset=utf-8",
                    //    timeout: 120000,
                    //    dataType: "json",
                    //    success: function (result) {
                    //        //alert(result.d);
                    //         window.location = 'barcode://?cmd=' + result.d + '&test=1&source=Barcode_Source_Doctor';
                    //    },
                    //    error: function (xhr, status) {
                    //    }
                    //});
                    for (var i = 0; i < NoofPrint; i++) {
                        data = data + "" + (data == "" ? "" : "^") + DoctorName + "#" + Department + "#" + Degree;
                    }
                  //  alert(data);
                    window.location = 'barcode://?cmd=' + data + '&test=1&source=Barcode_Source_Doctor';
                }
                else
                    return false;
            }
            else
                alert("Please Enter No of printOut at Least 1");
        }
        function checkprintOut(rowid) {
            var PrintOut = $.trim($(rowid).closest('tr').find("#txtPrint").val());
            if (PrintOut > 10) {
                $(rowid).closest('tr').find("#txtPrint").val('1');
                alert("Not more than 10");
                return false;
            }
        }
            function onlyNumeric(element, evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode
                if (
                    (charCode < 48 || charCode > 57) && (charCode != 8)) {
                    alert('Enter Numeric Value Only');
                    return false;
                }
                else {
                    $("#lblMsg").text(' ');
                    return true;
                }
            }
    </script>
    <div id="Pbody_box_inventory">
         <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctor Detail</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            <div class="Purchaseheader" >
                Search Criteria
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr >
                    <td style="width: 20%; text-align:right" >
                        Name :&nbsp;
                        
                    </td>
                    <td style="width: 30%; text-align: left;">
                     <asp:TextBox ID="txtName" ClientIDMode="Static"  runat="server" Width="150px" TabIndex="1" ></asp:TextBox>

                    </td>
                    <td style="width: 20%; text-align:right" >Contact No. :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left;">
                        <asp:TextBox ID="txtMobile" runat="server" ClientIDMode="Static"  MaxLength="15"
                            TabIndex="2" Width="150px" ></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftb" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </td>
                </tr>
                <tr >
                    <td style="width: 20%;  text-align:right" >Department :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left; ">
                     <asp:DropDownList ID="ddlDepartment" Width="156px" runat="server" ClientIDMode="Static" TabIndex="3"></asp:DropDownList>

                    </td>
                    <td style="width: 20%;  text-align:right" >Specialization :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left; ">
                    <asp:DropDownList ID="ddlSpecialization" TabIndex="4" runat="server" Width="156px" ClientIDMode="Static"></asp:DropDownList>

                      
                    </td>
                </tr>
                 
                
                <tr >
                    <td  style="text-align:center" colspan="4">
                        
                        <input type="button" id="btnSearch" tabindex="5" value="Search" class="ItDoseButton"  onclick="searchDoctor()"/>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader" >
                Search Result
            </div>
             <div id="DoctorOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
        </div>

    </div>

         <script id="tb_searchDoctor" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdDoctor"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:340px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Specialization</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Doctor Type</th>		          
            <th class="GridViewHeaderStyle" scope="col" style="width:180px; ">Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;display:none">DoctorID</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;display:none">DoctorDegree</th>			           
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">No. of Print</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
		</tr>
        <#       
        var dataLength=doctor.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = doctor[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdDoctorName"  style="width:340px;text-align:left" ><#=objRow.DName#></td>
                    <td class="GridViewLabItemStyle" id="tdDepartment"  style="width:240px;text-align:center" ><#=objRow.Department#></td>
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:240px;text-align:center" ><#=objRow.Specialization#></td>
                    <td class="GridViewLabItemStyle" id="tdRoleID" style="width:120px;text-align:center"><#=objRow.DocType#></td>
                    <td class="GridViewLabItemStyle" id="tdErrorID" style="width:180px;text-align:center"><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle" id="tdDoctorID" style="width:180px;text-align:center;display:none"><#=objRow.DoctorID#></td>
                        <td class="GridViewLabItemStyle" id="tdDegree" style="width:180px;text-align:center;display:none"><#=objRow.Degree#></td>
                          <td class="GridViewLabItemStyle" style="width:10px;"><input type="text" id="txtPrint" value="1" style="width:30px" class="ItDoseTextinputNum" onkeypress="return onlyNumeric(this,event)" onkeyup="return checkprintOut(this)" /></td>                
                           <td class="GridViewLabItemStyle" style="width:10px;"><img src="../../Images/print.gif"  style="cursor:pointer" onclick="PrintDoctorSticker(this)"/></td>
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

</asp:Content>



