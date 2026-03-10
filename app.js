console.log("App init");

fetch('profile.json')
    .then(response => response.json())
    .then(data => {
        const nameElement = document.querySelector('#name');
        nameElement.textContent = data.name;

        const skillsList = document.querySelector('#skills');
        data.skills.forEach(skill => {
            const li = document.createElement('li');
            li.textContent = skill;
            skillsList.appendChild(li);
        });

        const interestsContainer = document.querySelector('#interests');
        data.interests.forEach(interest => {
            const p = document.createElement('p');
            p.textContent = interest;
            interestsContainer.appendChild(p);
        });
    })
    .catch(error => {
        console.error('Chyba při načítání dat:', error);
    });
